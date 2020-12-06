json.extract! product, :id, :title, :tags, :price, :promoted, :created_at, :updated_at
json.url product_url(product, format: :json)
