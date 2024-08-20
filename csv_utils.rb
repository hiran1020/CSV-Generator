require 'csv'

# Function to save data to a CSV file with dynamic headers
def save_to_csv(filename, headers, data, data_processor)
  CSV.open(filename, 'w') do |csv|
    csv << headers
    data.each do |item|
      csv << data_processor.call(item)
    end
  end
end


# # Function to process other types of data (e.g., vehicles)
def process_data(data_type, data)
    case data_type
    when :filteredOrderWell
      data.map do |order|
        [
          order['ticketId'],
          order['status'],
          order['type'],
          Time.at(order['plannedAt']).strftime('%Y-%m-%d %H:%M:%S'),
          Time.at(order['createdAtTimestamp']).strftime('%Y-%m-%d %H:%M:%S'),
          order['customerName'],
          order['shipToName'],
          "#{order['deliveredGal']} gallons",
          order['hubName']
        ]
      end
    when :filteredCustomers
      data.map do |customer|
        [
          customer['id'],
          customer['name'],
          customer['erpId'],
          customer['poBoxNumber'],
          customer['address'],
          customer['creditChecked'],
          customer['status'],
          customer['customerBranches'].map { |branch| "#{branch['name']} (#{branch['address']})" }.join('; '),
          customer['hubs'].map { |hub| hub['name'] }.join('; ')
        ]
      end
    when :filteredAssets
      data.map do |asset|
        subscriptions = if asset['subscriptions'].is_a?(Array) && !asset['subscriptions'].empty?
                          asset['subscriptions'].map { |sub| "#{sub.dig('product', 'id') || '-'} (#{sub.dig('product', 'erpId') || '-'})" }.join('; ')
                        else
                          "No subscriptions"
                        end
  
        [
          asset['id'] || "-",
          asset['status'] || "-",
          asset['name'] || "-",
          asset['category'] || "-",
          asset['licensePlateNumber'] || "-",
          asset['erpId'] || "-",
          asset.dig('customer', 'name') || "-",
          asset.dig('customerBranch', 'name') || "-",
          subscriptions
        ]
      end
    when :filteredAddressBooks
      data.map do |poc|
        customer_name = poc.dig('customers', 0, 'name')
        branch_name = poc.dig('customerBranches', 0, 'name')
        
        [
          poc['id'],
          poc['name'],
          poc['phone'] || "NO - Phone",
          poc['email'],
          poc['address'] || "NO - Address",
          poc['addressBookType'],
          poc['hasAccessToCustomerPortal'],
          poc['isDeliveryTicketRecipient'],
          customer_name || branch_name || "-"
        ]
      end
    else
      []
    end
  end
  
















# # Function to append orders to an existing CSV file
# def append_orders_to_csv(csv, orders)
#   orders.each do |order|
#     csv << [
#       order['ticketId'],
#       order['status'],
#       order['type'],
#       Time.at(order['plannedAt']).strftime('%Y-%m-%d %H:%M:%S'),
#       Time.at(order['createdAtTimestamp']).strftime('%Y-%m-%d %H:%M:%S'),
#       order['customerName'],
#       order['shipToName'],
#       "#{order['deliveredGal']} gallons",
#       order['hubName']
#     ]
#   end
# end

# # Function to append customers to an existing CSV file
# def append_customers_to_csv(csv, customers)
#   customers.each do |customer|
#     csv << [
#       customer['id'],
#       customer['name'],
#       customer['erpId'],
#       customer['poBoxNumber'],
#       customer['address'],
#       customer['creditChecked'],
#       customer['status'],
#       # Handling customerBranches as an array
#       customer['customerBranches'].map { |branch| "#{branch['name']} (#{branch['address']})" }.join('; '),
#       # Handling hubs as an array
#       customer['hubs'].map { |hub| hub['name'] }.join('; ')
#     ]
#   end
# end

# # Function to append assets to an existing CSV file
# def append_assets_to_csv(csv, assets)
#   assets.each do |asset|
#     subscriptions = if asset['subscriptions'].is_a?(Array) && !asset['subscriptions'].empty?
#                       asset['subscriptions'].map { |sub| "#{sub.dig('product', 'id') || '-'} (#{sub.dig('product', 'erpId') || '-'})" }.join('; ')
#                     else
#                       "No subscriptions"
#                     end

#     csv << [
#       asset['id'] || "-",
#       asset['status'] || "-",
#       asset['name'] || "-",
#       asset['category'] || "-",
#       asset['licensePlateNumber'] || "-",
#       asset['erpId'] || "-",
#       asset.dig('customer', 'name') || "-",
#       asset.dig('customerBranch', 'name') || "-",
#       subscriptions
#     ]
#   end
# end

# def append_poc_to_csv(csv, pocs)
#     pocs.each do |poc|
#         customer_name = poc.dig('customers', 0, 'name')
#         branch_name = poc.dig('customerBranches', 0, 'name')
      
#       csv << [
#         poc['id'],
#         poc['name'],
#         poc['phone'] || "NO - Phone",
#         poc['email'],
#         poc['address'] || "NO - Address",
#         poc['addressBookType'],
#         poc['hasAccessToCustomerPortal'],
#         poc['isDeliveryTicketRecipient'],
#         customer_name || branch_name || "-"
#       ]
#     end
#     puts "POCs appended to CSV successfully."
#   end
  
