class Avo::Resources::Plan < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :stripe_price_id, as: :text
    field :amount, as: :number
    field :currency, as: :text
    field :interval, as: :text
    field :features, as: :textarea
  end
end
