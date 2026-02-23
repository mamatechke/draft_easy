class Avo::ApplicationResource < Avo::BaseResource
end

class Avo::UserResource < Avo::BaseResource
  field :id, as: :id
  field :email, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :admin, as: :boolean
  field :verified, as: :boolean
  field :plan, as: :belongs_to
  field :cases, as: :has_many
  field :created_at, as: :date_time
end

class Avo::CaseResource < Avo::BaseResource
  field :id, as: :id
  field :case_name, as: :text
  field :user, as: :belongs_to
  field :summary, as: :text
  field :created_at, as: :date_time
end

class Avo::PlanResource < Avo::BaseResource
  field :id, as: :id
  field :name, as: :text
  field :amount, as: :number
  field :stripe_price_id, as: :text
end
