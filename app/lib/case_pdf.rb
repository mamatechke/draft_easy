require "prawn"

class CasePdf < Prawn::Document
  def initialize(case_record)
    super()
    @case = case_record
    header
    body
  end

  def header
    text @case.case_name.to_s, size: 20, style: :bold
    move_down 10
    text "Court: #{@case.court} | Year: #{@case.decision_year} | Jurisdiction: #{@case.jurisdiction}"
    text "Citation: #{@case.citation}"
    move_down 10
  end

  def body
    section("Case Name", @case.case_name)
    section("Citation", @case.citation)
    section("Court", @case.court)
    section("Jurisdiction", @case.jurisdiction)
    section("Year", @case.decision_year)
    section("Procedural History", @case.procedural_history)
    section("Facts", @case.facts)
    section("Legal Issue", @case.legal_issue)
    section("Holding", @case.holding)
    section("Rule of Law", @case.rule_of_law)
    section("Reasoning", @case.reasoning)
    section("Conclusion", @case.conclusion)
    section("Concurring Opinions", @case.concurring_opinions)
    section("Dissenting Opinions", @case.dissenting_opinions)
  end

  def section(title, content)
    move_down 8
    text title, style: :bold, size: 14
    move_down 2
    text content.to_s, size: 11
  end
end
