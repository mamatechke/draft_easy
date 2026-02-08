class Avo::Resources::Case < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :case_name, as: :text, readonly: true
    field :citation, as: :text, readonly: true
    field :court, as: :text, readonly: true
    field :jurisdiction, as: :text, readonly: true
    field :decision_year, as: :number, readonly: true
    field :case_type, as: :text, readonly: true
    field :parties, as: :textarea, readonly: true
    field :deadline, as: :date, readonly: true
    field :user, as: :belongs_to, readonly: true
    field :summary, as: :textarea, readonly: true
    field :draft_style, as: :text, readonly: true
  end
end
