class GithubRetrieveService

  def initialize(username)
    @username = username
  end

  def retrieve_user
    user_resource = Octokit.user(@username)
    return GithubSyncService.new(@username).synchronize_user if User.find_by(username: @username)

    user = User.create(username: @username, followers: user_resource.followers)
    get_repos_for(user_resource).each do |repo_attributes|
      Repository.create(name: repo_attributes[:name],
                        creation_date: Date.parse(repo_attributes[:created_at]),
                        stars: repo_attributes[:stargazers_count],
                        user_id: user.id)
    end

    user
  end

  private

  def get_repos_for(user_resource)
    user_resource.rels[:repos].get.data
  end

end
