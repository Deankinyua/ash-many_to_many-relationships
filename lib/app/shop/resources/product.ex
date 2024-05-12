defmodule App.Shop.Product do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "products"
    repo(App.Repo)
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :price, :decimal
  end

  relationships do
    many_to_many :tags, App.Shop.Tag do
      through App.Shop.ProductTag
      source_attribute_on_join_resource :product_id
      destination_attribute_on_join_resource :tag_id
    end
  end

  actions do
    defaults [:destroy]

    read :read do
      primary? true
      prepare build(load: [:tags])
    end

    create :create do
      primary? true
      argument :tags, {:array, :map}

      argument :add_tag, :map do
        allow_nil? true
      end

      change manage_relationship(:tags,
               type: :append_and_remove,
               on_no_match: :create
             )

      change manage_relationship(
               :add_tag,
               :tags,
               type: :create
             )
    end

    update :update do
      primary? true
      argument :tags, {:array, :map}

      change manage_relationship(:tags,
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
