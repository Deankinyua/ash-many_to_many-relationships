defmodule App.Shop.ProductTag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "product_tags"
    repo(App.Repo)
  end

  actions do
    defaults [:create, :read, :destroy]
  end

  relationships do
    belongs_to :product, App.Shop.Product do
      primary_key? true
      allow_nil? false
    end

    belongs_to :tag, App.Shop.Tag do
      primary_key? true
      allow_nil? false
    end
  end
end
