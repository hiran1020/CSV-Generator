require 'net/http'
require 'json'
require 'uri'

# Function to fetch data from the GraphQL API
# Function to fetch data from the GraphQL API
def fetch_data(url, headers, query, variables)
  uri = URI(url)
  request = Net::HTTP::Post.new(uri, headers)
  request.body = { query: query, variables: variables }.to_json

  # Print headers and request body for debugging
  puts "Request Headers: #{headers.inspect}"
  puts "Request Body: #{request.body}"

  begin
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    # Check for redirection
    if response.is_a?(Net::HTTPRedirection)
      puts "Redirection detected: #{response['location']}"
      return nil
    end

    # Parse the response body
    JSON.parse(response.body)

  rescue SocketError => e
    puts "Network error: #{e.message}"
    nil
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
    nil
  end
end

