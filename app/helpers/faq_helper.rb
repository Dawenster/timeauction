module FaqHelper
  def sections
    return [
      {
        :name => "General",
        :id => "gen",
        :questions => [
          {
            :question => "How does it work?",
            :answer_paragraphs => [
              "First you browse all the auctions we have and find one that you like. There’s a minimum amount of Karma Points you need for each auction before you can bid. You can earn Karma Points by either volunteering, donating, or a mix of both!"
            ],
            :section => "general"
          },
          {
            :question => "What are Karma Points?",
            :answer_paragraphs => [
              "Karma Points are Time Auction’s form of currency. Each hour you volunteer or $10 you donate earns you 10 Karma Points. For example, if a bid has a minimum of 20 Karma Points, you can bid 1 volunteer hour and donate $10 to earn the required Karma Points. You don’t have to pay anything if you bid 2 volunteer hours. We also understand not everyone has time to go out and volunteer. So if you don’t feel like volunteering, simply donate $20 and you’re on your way!"
            ],
            :section => "general"
          },
          {
            :question => "What do you mean by bidding volunteer hours?",
            :answer_paragraphs => [
              "We want you to go out and volunteer. That is why we accept your past volunteer hours as a form of currency (Karma Points). Any volunteer hours you’ve completed in 2015 will count towards your Karma Points. Simply log them in on your profile or when bidding on an auction. Note that if you are participating in a Time Auction run by a specific organization, the time frame in which hours will count might be different."
            ],
            :section => "general"
          },
          {
            :question => "So… what do you mean by “auction”?",
            :answer_paragraphs => [
              "There are two types of Time Auctions. The first type is the 'Webinar' type. Quite simply, if you bid on this type of auction, you automatically win. These auctions are typically webinars or group sessions, and some might have a target number of hours that it needs to raise in order to unlock the auction for everyone.",
              "The second type of auction is the 'Draw' type. In these auctions, there are a limited number of spots available. Your bid is entered into a draw for these spots. If your bid is drawn, and Time Auction verifies that your volunteer hours are legit, then the reward is yours!",
              "Some auctions might have elements of both types, so be sure to read the descriptions carefully."
            ],
            :section => "general"
          },
          {
            :question => "How does the draw work?",
            :answer_paragraphs => [
              "Each reward has its own draw. The draw is basic probability, with each Karma Point counting as one entry. For example, if a reward has collected 100 Karma Points at the end of the bidding period, and you had bid 10 Karma Points on that reward, then you will have a 10% chance of winning that reward (10 entries out of 100 total entries).",
              "If a reward has multiple spots available, then subsequent draws will exclude the entries of the person who won the first spot. Continuing the example from earlier, if the first person to win had bid 20 Karma Points, you will now have a 12.5% chance of winning the second spot (10 entries out of 80 remaining entries).",
              "We use a random number generator to select the winner. The code for this is open for review and can be found here. Note that people who were selected by the draw will still need to be approved by the reward donor prior to being declared a winner. This is for the safety of our donors."
            ],
            :section => "general"
          },
          {
            :question => "How do you validate my hours?",
            :answer_paragraphs => [
              "When you log your hours, we ask you to provide us with the name of the organization you volunteered at. We will also ask for the name, number, and email of a supervisor or colleague. We will then do our due diligence and if everything checks out, then your hours are verified."
            ],
            :section => "general"
          },
          {
            :question => "Will I get a donation receipt?",
            :answer_paragraphs => [
              "Not at the moment. Unfortunately due to Canada Revenue Agency’s rules, donation receipts cannot be issued when something is received back from a donation. We are currently working on a way to be able to issue  donation receipts for a portion of the donation."
            ],
            :section => "general"
          },
          {
            :question => "Are there certain time constraints?",
            :answer_paragraphs => [
              "The period in which volunteer hours need to have been completed differs per auction, but they typically need to be done in the last 3 months (inclusive) before the date of your bid."
            ],
            :section => "general"
          },
          {
            :question => "Is Time Auction a charity?",
            :answer_paragraphs => [
              "Nope! We are a social enterprise that aligns our social cause with our business interests."
            ],
            :section => "general"
          },
          {
            :question => "How do you make money?",
            :answer_paragraphs => [
              "When you donate to a charity, you have an option to leave us a tip. The amount of the tip you leave is up to you, but keep in mind that we have to pay a 2.9% fee on transactions plus 25 cents, so we would appreciate if you could at least tip us something. Time Auction also helps organizations run private Time Auctions for their constituents on our platform. We charge them for these services."
            ],
            :section => "general"
          }
        ]
      }
    ]
  end
end