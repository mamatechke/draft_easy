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

    # Add AI Summary if present
    if @case.summary.present?
      move_down 16
      text "AI Summary", style: :bold, size: 16, color: "00897B"
      move_down 4
      text @case.summary.to_s, size: 12, style: :italic
    end

    # Add future additions here (e.g., user notes, attachments)
    # Example:
    # section("User Notes", @case.user_notes)
  end

  def section(title, content)
    move_down 8
    text title, style: :bold, size: 14
    move_down 2
    text content.to_s, size: 11
  end
end
