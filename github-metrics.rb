unless ARGV.length == 2
    puts "Returns a list of commits by every contributor in source repositories belonging to an org.\n\n"
    puts "Usage: ruby github-metrics.rb <org_name> <access_token>\n"
    exit
end

org = ARGV[0]
access_token = ARGV[1]

require 'octokit'

github = Octokit::Client.new :access_token => access_token
totals = Hash.new
totals.default = 0

github.org_repositories(org, :query => {:type => 'source'}).each do |r|
    # puts "lumeohq/#{r.name}"
    stats = github.contributor_stats("#{org}/#{r.name}")
        if stats
            stats.each do |s|
            totals[s.author.login] += s.total
        end
    end 
end

totals.sort_by{|k, v| v}.reverse.to_h.each do |k,v| 
    puts "#{k} - #{v}\n"
end



