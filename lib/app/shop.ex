defmodule App.Shop do
  use Ash.Api

  resources do
    resource App.Shop.Product
    resource App.Shop.ProductTag
    resource App.Shop.Tag
  end
end
