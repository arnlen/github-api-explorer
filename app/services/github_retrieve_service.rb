class GithubRetrieveService

  def initialize(username)
    @username = username
  end

  def retrieve_user
    user_resource = get_resource
    if user = User.find_by(username: @username)
      return GithubSyncService.new(user).synchronize_user_with(user_resource)
    end

    User.create(username: @username, followers: user_resource.followers).tap do |user|
      get_repos_for(user_resource).each do |repo_attributes|
        create_repository_from_attributes(repo_attributes, user)
      end
    end
  end

  private

  def get_resource
    Octokit.user(@username)
  end

  # DUPLICATION (Arnaud Lenglet): duplicated in GithubSyncService
  def get_repos_for(user_resource)
    user_resource.rels[:repos].get.data
  end

  def create_repository_from_attributes(repo_attributes, user)
    Repository.create(name: repo_attributes[:name],
                      creation_date: repo_attributes[:created_at].to_date,
                      stars: repo_attributes[:stargazers_count],
                      user_id: user.id)
  end

end
