require 'time'

# Define the queries as a hash with named keys
module GraphQLQueries
  FILTERED_CUSTOMERS = <<-GRAPHQL
    query($limit: Int, $offset: Int, $sorter: [BaseSorter!]) {
      filteredCustomers(
        limit: $limit
        offset: $offset
        sorter: $sorter
      ) {
        collection {
          id
          name
          erpId
          poBoxNumber
          address
          creditChecked
          status
          customerBranches {
            name
            address
          }
          hubs {
            name
          }
        }
        metadata {
          totalCount
        }
      }
    }
  GRAPHQL

  FILTERED_ORDER_WELL = <<-GRAPHQL
    query($limit: Int, $offset: Int, $fromTimestamp: Int, $toTimestamp: Int) {
      filteredOrderWell(
        limit: $limit
        offset: $offset
        filter: {fromTimestamp: $fromTimestamp, toTimestamp: $toTimestamp}
      ) {
        collection {
          ticketId
          status
          type
          plannedAt
          createdAtTimestamp
          customerName
          shipToName
          deliveredGal
          hubName
        }
        metadata {
          totalCount
        }
      }
    }
  GRAPHQL

  Filtered_Assets = <<-GRAPHQL
    query fetchCustomerAssets($limit: Int, $offset: Int, $sorter: [AssetSorter!], $customerIds: [ID!], $customerBranchId: [ID!], $filter: String, $types: [AssetTypeEnum!]) {
      filteredAssets(limit: $limit, offset: $offset, sorter: $sorter, filter: {customerIds: $customerIds, customerBranchId: $customerBranchId, all: $filter, types: $types}) {
        collection {
          id
          status
          name
          category
          licensePlateNumber
          erpId
          customer {
            name
           
          }
          customerBranch {
              name
          }
          subscriptions {
            product {
              id
              erpId
              productType
            }
          }
        }
        metadata {
          totalCount
        }
      }
    }
  GRAPHQL

  FilteredAddressBooks = <<-GRAPHQL
      query FilteredAddressBooks($limit: Int, $offset: Int, $all: String, $sorter: [AddressBookSorter!]) {
        filteredAddressBooks(
        limit: $limit
        offset: $offset
        sorter: $sorter
        filter: {all: $all}
      ) {
    collection {
      id
      name
      phone
      email
      address
      addressBookType
      hasAccessToCustomerPortal
      isDeliveryTicketRecipient
      showInviteLink
      customers {
        name
      }
      customerBranches {
        name
      }
    }
    metadata {
      totalCount
      }
    }
  }
    GRAPHQL
end


def get_query(query_type)
  case query_type
  when :filtered_customers
    GraphQLQueries::FILTERED_CUSTOMERS
  when :filtered_order_well
    GraphQLQueries::FILTERED_ORDER_WELL
  when :filteredAssets
    GraphQLQueries::Filtered_Assets
  when :filteredAddressBooks
    GraphQLQueries::FilteredAddressBooks
  else
    raise "Unknown query type: #{query_type}"
  end
end


# Date range for fetching orders
START_DATE = "2024-08-17"
END_DATE = "2024-08-18"

# Convert dates to timestamps
def get_timestamp(date_str)
  Time.parse(date_str).to_i
end

START_TIMESTAMP = get_timestamp(START_DATE)
END_TIMESTAMP = get_timestamp(END_DATE)

# Query variables for orders (example)
ORDER_VARIABLES = {
  limit: 40,
  offset: 0,
  fromTimestamp: START_TIMESTAMP,
  toTimestamp: END_TIMESTAMP
}

# Query variables for customers (example)
CUSTOMER_VARIABLES = {
  limit: 30,
  offset: 0,
  # sorter: [
  #   {
  #     field: "name",
  #     order: "asc"
  #   }
  # ]
}

# Query variables for customer assets (example)
CUSTOMER_ASSET_VARIABLES ={
  "limit": 40,
  "offset": 0,
}

# Query variables for address books (example)
ADDRESS_BOOK_VARIABLES = {
  "limit": 30,
  "offset": 0,
}