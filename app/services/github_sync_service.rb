class GithubSyncService

  def initialize(user)
    @user = user
  end

  def synchronize_user_with(resource)
    @user.update_attribute(:followers, resource.followers) if @user.followers != resource.followers
    local_repositories = @user.repositories
    github_repositories = get_repos_for(resource)

    local_repositories.each do |repository|
      delete_repository_if_gone(repository, github_repositories)
      update_repository_if_needed(repository, github_repositories)
    end

    create_missing_repositories(local_repositories, github_repositories)

    @user
  end

  private

  # DUPLICATION (Arnaud Lenglet): duplicated in GithubRetrieveService
  def get_repos_for(user_resource)
    user_resource.rels[:repos].get.data
  end

  def create_repository_from_attributes(repo_attributes)
    Repository.create(name: repo_attributes[:name],
                      creation_date: Date.parse(repo_attributes[:created_at]),
                      stars: repo_attributes[:stargazers_count],
                      user_id: @user.id)
  end

  def delete_repository_if_gone(repository, github_repositories)
    unless github_repositories.any? { |repo_attributes| repo_attributes[:name] == repository.name }
      repository.delete
    end
  end

  def update_repository_if_needed(repository, github_repositories)
    github_repositories.each do |repo_attributes|
      if repo_attributes[:name] == repository.name
        unless repo_attributes[:stargazers_count] == repository.stars
          repository.update_attribute(:stars, repo_attributes[:stargazers_count])
        end
      end
    end
  end

  def create_missing_repositories(local_repositories, github_repositories)
    github_repositories.each do |repo_attributes|
      unless local_repositories.pluck(:name).include?(repo_attributes[:name])
        create_repository_from_attributes(repo_attributes)
      end
    end
  end

end
