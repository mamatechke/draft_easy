puts 'Seeding plans'
Plan.destroy_all

Plan.create!(
  name: 'Free',
  stripe_price_id: nil,
  amount: 0,
  currency: 'usd',
  interval: 'month',
  features: '5 cases, Basic AI summarization, 1 precedent search per case'
)

pro_plan = Plan.create!(
  name: 'Pro',
  stripe_price_id: 'price_pro_monthly', # Replace with actual Stripe price ID
  amount: 2900, # $29.00
  currency: 'usd',
  interval: 'month',
  features: 'Unlimited cases, Advanced AI features, Unlimited precedent searches, Word export, Priority support'
)

puts "Seeded #{Plan.count} plans"

puts 'Seeding admin user'
admin = User.find_or_initialize_by(email: 'admin@draftease.com')
admin.first_name = 'Admin'
admin.last_name = 'User'
admin.password = 'admin123'
admin.password_confirmation = 'admin123'
admin.admin = true
admin.verified = true
admin.plan = pro_plan
admin.save!
puts "Seeded admin user: #{admin.email}"

if Rails.env.development?
  puts 'Deleting all users except lawyer1@drafting.com in development environment only'
  User.where.not(email: 'lawyer1@drafting.com').destroy_all
  user = User.find_or_initialize_by(email: 'lawyer1@drafting.com')
  user.first_name = 'Lawyer1'
  user.last_name = 'Drafting'
  user.password = 'password123'
  user.verified = true
  user.plan = pro_plan # Assign pro plan to seeded user
  user.save!
  puts "Seeded user #{user.email}"
end

puts 'Seeding users completed'
if Rails.env.development?
  user = User.find_by(email: 'lawyer1@drafting.com')
  if user
    puts "Seeding demo cases for user: #{user.email}"
    Case.where(user: user).destroy_all
    Case.create!(
      user: user,
      case_name: 'Mwangi v. National Bank',
      citation: 'Civil Appeal No. 45 of 2018',
      court: 'Court of Appeal',
      jurisdiction: 'Kenya',
      decision_year: 2020,
      procedural_history: "The High Court dismissed the plaintiff's claim for wrongful termination. The plaintiff appealed the decision to the Court of Appeal.",
      facts: 'The plaintiff was employed by the defendant bank for ten years before being summarily dismissed following allegations of gross misconduct. No disciplinary hearing was conducted prior to termination.',
      legal_issue: "Whether the defendant violated the principles of natural justice by terminating the plaintiff's employment without a hearing.",
      holding: 'Yes. The termination was unlawful.',
      rule_of_law: 'An employer must accord an employee a fair hearing before termination, in accordance with principles of natural justice and employment law.',
      reasoning: 'The court found that the failure to conduct a disciplinary hearing denied the plaintiff an opportunity to respond to the allegations. This omission rendered the termination procedurally unfair.',
      conclusion: 'The appeal was allowed, and the plaintiff was awarded damages for unlawful termination.',
      concurring_opinions: nil,
      dissenting_opinions: nil
    )
    Case.create!(
      user: user,
      case_name: 'State v. Kamau',
      citation: 'Criminal Case No. 112 of 2019',
      court: 'High Court',
      jurisdiction: 'Kenya',
      decision_year: 2021,
      procedural_history: "The accused was convicted in the Magistrate's Court and appealed the conviction to the High Court.",
      facts: 'The accused was charged with robbery with violence. The prosecution relied primarily on eyewitness testimony obtained at night under poor lighting conditions.',
      legal_issue: 'Whether the conviction was safe given the reliance on uncorroborated eyewitness identification.',
      holding: 'No. The conviction was unsafe.',
      rule_of_law: 'A conviction based on visual identification must be supported by clear, reliable, and corroborated evidence, especially in difficult conditions.',
      reasoning: 'The court held that the conditions for identification were unfavorable and that no corroborative evidence linked the accused to the crime.',
      conclusion: 'The conviction was quashed and the sentence set aside.',
      concurring_opinions: nil,
      dissenting_opinions: nil
    )
    Case.create!(
      user: user,
      case_name: 'GreenEarth Ltd v. County Government',
      citation: 'Judicial Review Application No. 7 of 2022',
      court: 'Environment and Land Court',
      jurisdiction: 'Kenya',
      decision_year: 2023,
      procedural_history: 'The applicant sought judicial review orders following the cancellation of an environmental license by the county authority.',
      facts: 'The applicant held a valid license to operate a waste recycling plant. The county government revoked the license without prior notice or reasons.',
      legal_issue: "Whether the revocation of the license violated the applicant's right to fair administrative action.",
      holding: 'Yes. The revocation was unlawful.',
      rule_of_law: 'Administrative bodies must act lawfully, reasonably, and procedurally fairly when making decisions affecting rights.',
      reasoning: 'The court found that the failure to give notice or reasons breached statutory and constitutional requirements for fair administrative action.',
      conclusion: 'An order of certiorari was issued quashing the revocation decision.',
      concurring_opinions: nil,
      dissenting_opinions: nil
    )
    Case.create!(
      user: user,
      case_name: 'TechNova Solutions v. Alpha Systems',
      citation: 'Commercial Suit No. 88 of 2021',
      court: 'Commercial Division of the High Court',
      jurisdiction: 'Kenya',
      decision_year: 2022,
      procedural_history: 'The plaintiff filed suit alleging breach of a software development contract.',
      facts: 'The parties entered into a contract for the delivery of a custom software platform. The defendant failed to deliver the system within the agreed timeline.',
      legal_issue: 'Whether the defendant was in breach of contract and liable for damages.',
      holding: 'Yes. The defendant breached the contract.',
      rule_of_law: 'A party who fails to perform contractual obligations within the agreed time without lawful excuse is in breach of contract.',
      reasoning: 'The court held that time was of the essence and that the defendant provided no justification for the delay.',
      conclusion: 'Judgment was entered for the plaintiff with damages for breach of contract.',
      concurring_opinions: nil,
      dissenting_opinions: nil
    )
    Case.create!(
      user: user,
      case_name: 'Amina Hassan v. Registrar of Persons',
      citation: 'Constitutional Petition No. 14 of 2020',
      court: 'High Court (Constitutional Division)',
      jurisdiction: 'Kenya',
      decision_year: 2021,
      procedural_history: 'The petitioner filed a constitutional petition challenging the refusal to issue a national identity card.',
      facts: 'The petitioner was denied an identity card on grounds of insufficient documentation, despite being born and educated in Kenya.',
      legal_issue: "Whether the refusal violated the petitioner's constitutional rights to equality and dignity.",
      holding: "Yes. The petitioner's rights were violated.",
      rule_of_law: 'Administrative actions must not unjustifiably infringe constitutional rights, including equality and human dignity.',
      reasoning: 'The court found the decision arbitrary and unsupported by evidence, disproportionately affecting the petitioner.',
      conclusion: 'The respondent was ordered to issue the identity card and pay costs.',
      concurring_opinions: nil,
      dissenting_opinions: nil
    )
    puts 'Seeded 5 high-quality demo cases.'
  else
    puts 'No users found to seed cases.'
  end
end
