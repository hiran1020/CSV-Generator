require_relative 'fetch_data'
require_relative 'config_auth'
require_relative 'csv_utils'
require_relative 'queries_gql'
require 'fileutils'

def fetch_and_save_data(data_type, query, variables, filename, headers)
  total_fetched = 0
  total_items = nil
  
  # Ensure the file exists; create it if it doesn't
  FileUtils.touch(filename)

  # Open CSV file in append mode
  CSV.open(filename, 'a') do |csv|
    # Write headers only if the file is empty
    if File.size(filename).zero?
      csv << headers
    end

    loop do
      puts "Fetching #{data_type} data with variables: #{variables}"
      begin
        data_response = fetch_data(API_URL, HEADERS, query, variables)
        puts "Data response: #{data_response}"
      rescue => e
        puts "Error fetching data: #{e.message}"
        break
      end

      # Handle redirections
      if data_response.is_a?(Net::HTTPRedirection)
        puts "Redirection detected: #{data_response['location']}"
        break
      end

      data = data_response&.dig('data', data_type.to_s)

      if data.nil?
        puts "No data returned for #{data_type}. Possible issue with the query or response structure."
        break
      end

      # Initialize total_items if this is the first batch of data
      if total_items.nil? && data_type == :filteredOrderWell
        total_items = data.dig('metadata', 'totalCount')
      end

      # Check if there are no more items to fetch
      if data['collection'].empty?
        puts "No more data to fetch for #{data_type}."
        break
      end

      fetched_count = data['metadata']['totalCount']
      total_fetched += fetched_count
      remaining_items = total_items ? total_items - total_fetched : 'unknown'

      puts "Fetched #{total_fetched} #{data_type}. #{remaining_items} #{data_type} remaining."

      # Process and append data to CSV
      csv_data = process_data(data_type, data['collection'])
      csv_data.each { |row| csv << row }

      # Update offset for pagination
      variables[:offset] += variables[:limit]
    end
  end

  puts "#{data_type.to_s.capitalize} data has been saved to #{filename}"
end


# Fetch and save customer data
# fetch_and_save_data(:filteredCustomers, get_query(:filtered_customers), CUSTOMER_VARIABLES, "customers.csv", ['Customer ID', 'Name', 'erpId', 'poBoxNumber', 'address', 'creditChecked', 'status', 'customerBranches', 'hubs'])
# fetch_and_save_data(:filteredOrderWell,get_query(:filtered_order_well), ORDER_VARIABLES, "orders.csv", ['Order ID', 'Status', 'Type', 'Planned At', 'Created At', 'Customer Name', 'Ship To Name', 'Delivered Gal', 'Hub Name'])
# fetch_and_save_data(:filteredAssets, get_query(:filteredAssets), CUSTOMER_ASSET_VARIABLES, "customer_assets.csv", ['Asset ID', 'Status', 'Name', 'Category', 'License Plate Number', 'ERP ID', 'Customer Name', 'Customer Branches', 'Subscriptions'])
# fetch_and_save_data(:filteredAddressBooks, get_query(:filteredAddressBooks), ADDRESS_BOOK_VARIABLES, "address_books.csv", ['Address Book ID', 'Name','Phone', 'Email' ,'Address', 'addressBookType', 'hasAccessToCustomerPortal', 'isDeliveryTicketRecipient','Customer Name'])
