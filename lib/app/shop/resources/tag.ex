defmodule App.Shop.Tag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tags"
    repo(App.Repo)
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
  end

  identities do
    identity :name, [:name] do
      pre_check_with App.Shop
    end
  end

  relationships do
    many_to_many :products, App.Shop.Product do
      through App.Shop.ProductTag
      source_attribute_on_join_resource :tag_id
      destination_attribute_on_join_resource :product_id
    end
  end

  actions do
    defaults [:update, :destroy]

    read :read do
      primary? true
      prepare build(load: [:products])
    end

    create :create do
      primary? true
      argument :products, {:array, :map}

      change manage_relationship(:products,
               type: :append_and_remove,
               on_no_match: :create
             )
    end
  end

  code_interface do
    define_for App.Shop
    define :create
    define :read
    define :by_id, get_by: [:id], action: :read
    define :by_name, get_by: [:name], action: :read
    define :update
    define :destroy
  end
end
