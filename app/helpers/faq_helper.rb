module FaqHelper
  def sections
    return [
      {
        :name => "General",
        :id => "gen",
        :questions => [
          {
            :question => "How does Time Auction work?",
            :answer_paragraphs => [
              "First, you browse all the auctions we have and find one that you like. Our auctions are all experiences with inspiring people from all walks of life. There’s a minimum amount of Karma Points you need for each auction before you can bid. You can earn Karma Points by either volunteering, donating, or both!"
            ],
            :section => "general"
          },
          {
            :question => "What are Karma Points?",
            :answer_paragraphs => [
              "Karma Points is Time Auction’s form of currency. Each hour you volunteer earns you #{volunteer_conversion_in_words} and each dollar you donate earns you #{donation_conversion_in_words}. For example, if an auction has a minimum bid of 20 Karma Points, you can either volunteer 2 hours, donate $20, or volunteer 1 hour and donate $10 to earn the required Karma Points."
            ],
            :section => "general"
          },
          {
            :question => "How are these 'Auctions'?",
            :answer_paragraphs => [
              "The word 'auction' in our context is a bit of a misnomer. Most people think of auctions as being top-bidder-wins contests, which is not the case on Time Auction (it used to be, but we've since tweaked the way we operate).",
              "On Time Auction, there are two types of auctions. The first type is the 'Webinar' type. If you bid on this type of auction, you automatically win. These auctions are typically Google Hangouts or group sessions, and some might have a target number of hours that it needs to raise in order to unlock the auction for everyone.",
              "The second type of auction is the 'Draw' type. In these auctions, there are a limited number of spots available. Your bid is entered into a draw for these spots. If your bid is drawn, and Time Auction verifies that your volunteer hours are legit, then the reward is yours!",
              "Time Auctions can be webinar style, draw style, or both, so be sure to read the descriptions carefully."
            ],
            :section => "general"
          },
          {
            :question => "How does the webinar work?",
            :answer_paragraphs => [
              "The webinar will be in a Q&A format, moderated by Time Auction. Questions will be submitted in advance by all the bidders on the auction. Bidders can indicate whether they'd like to ask their questions themselves, have Time Auction ask for them, or not ask a question at all and just listen.",
              "If a bidder wishes to ask the question live, Time Auction would make the bidder live on the webinar so the bidder can ask in real time, with the webcam going. All calls are recorded and shared with bidders so they can watch it afterwards as well."
            ],
            :section => "general"
          },
          {
            :question => "How does the draw work?",
            :answer_paragraphs => [
              "Auctions that have a draw are based on basic probability, with each Karma Point counting as one entry. For example, if a reward has collected 100 Karma Points at the end of the bidding period, and you had bid 10 Karma Points on that reward, then you will have a 10% chance of winning that reward (10 entries out of 100 total entries).",
              "If a reward has multiple spots available, then subsequent draws will exclude the entries of the person who won the first spot. Continuing the example from earlier, if the first person to win had bid 20 Karma Points, you will now have a 12.5% chance of winning the second spot (10 entries out of 80 remaining entries).",
              "We use a random number generator to select the winner. The code for this is open for review and can be found #{view_context.link_to 'here', 'https://github.com/Dawenster/timeauction/blob/master/lib/tasks/draw.rake', :target => '_blank'}. Note that people who were selected by the draw will still need to be approved by the reward donor prior to being declared a winner. This is for the safety of our donors."
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
              "When you donate to a charity, you have an option to leave us a tip. The amount of the tip you leave is up to you, but keep in mind that we have to pay a #{view_context.link_to '2.9% fee plus 30 cents per transaction', 'https://stripe.com/ca/pricing', :target => '_blank'}, so we would appreciate if you could at least tip us something!",
              "Additionally, Time Auction sometimes helps organizations run private Time Auctions for their constituents on our platform. We charge them for these services."
            ],
            :section => "general"
          }
        ]
      },
      {
        :name => "Volunteering",
        :id => "vol",
        :questions => [
          {
            :question => "What volunteer hours count?",
            :answer_paragraphs => [
              "Any volunteer hours you’ve completed #{general_eligible_period} will count towards your Karma Points. Simply log them from the 'Add Karma' link in the menu or when bidding on an auction. Note that if you are participating in a private Time Auction run by a specific organization, the time frame in which hours will count might be different.",
              "Volunteering for any nonprofit, school club, or social enterprise counts. <a data-reveal-id='what-counts-as-hours-modal'>Click here to see what types of volunteer work is eligible.</a>"
            ],
            :section => "general"
          },
          {
            :question => "How do you validate my hours?",
            :answer_paragraphs => [
              "When you log your hours, we ask you to provide us with the name of the organization you volunteered at. We will also ask for the name, number, and email of a supervisor or colleague who can vouch for you. We will then do our due diligence and if everything checks out, then your hours are verified."
            ],
            :section => "general"
          },
          {
            :question => "Can I do my volunteer hours at multiple organizations?",
            :answer_paragraphs => [
              "Yup! Spread that love :)"
            ],
            :section => "general"
          },
          {
            :question => "I've never volunteered before, what should I do?",
            :answer_paragraphs => [
              "You should try it out! Time Auction has new auctions all the time so by the time you log some volunteer hours we'll have other auctions that you might like to bid on with your newly-earned hours."
            ],
            :section => "general"
          },
          {
            :question => "Can you help me find a volunteering opportunity?",
            :answer_paragraphs => [
              "We provide a #{view_context.link_to 'list of resources', opportunities_path} to help users find volunteering opportunities. That said, it is up to you to find a volunteering opportunity that you enjoy.",
              "If you're participating in a Time Auction run by your organization, your organization may already have opportunities for you. Check with your dedicated Time Auction support if you still have questions."
            ],
            :section => "general"
          }
        ]
      },
      {
        :name => "Donating",
        :id => "don",
        :questions => [
          {
            :question => "Will I get a donation receipt?",
            :answer_paragraphs => [
              "You will get an email receipt from our payment provider, Stripe, confirming that your payment has gone through.",
              "In terms of an official donation receipt from a charity for income tax purposes, unfortunately we cannot issue that at the moment. Due to Canada Revenue Agency’s rules, charitable donation receipts cannot be issued when something of tangible value is received in exchange for a donation. This is something we are following closely, and we will be sure to notify users if anything changes."
            ],
            :section => "general"
          },
          {
            :question => "Why was I charged a currency conversion fee?",
            :answer_paragraphs => [
              "For now, Time Auction accepts everything in Canadian Dollars (CAD), which means if you're using a non-Canadian dollar credit card, you may be charged a currency conversion fee by your credit card provider."
            ],
            :section => "general"
          }
        ]
      }
    ]
  end
end