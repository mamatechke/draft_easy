class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :admin, as: :boolean
    field :email, as: :text
    field :first_name, as: :text
    field :last_name, as: :text
    field :subscribed, as: :boolean
    field :trial_ends_at, as: :date_time
    field :verified, as: :boolean
    field :provider, as: :text
    field :uid, as: :text
    field :stripe_customer_id, as: :text
    field :plan_id, as: :number
    field :cases, as: :has_many
    field :plan, as: :belongs_to
    field :sessions, as: :has_many
  end
end
