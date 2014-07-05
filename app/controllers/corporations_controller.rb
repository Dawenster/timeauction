class CorporationsController < ApplicationController
  def overview
    @testimonials = [
      {
        :message => "\"Thank you Time Auction for your dedication to make this opportunity a reality. I will forever cherish the meeting with Mr. Joyce as a real highlight in my life.\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/wanda.jpg",
        :bidder_name => "Wanda Swensen",
        :auction_id => 15
      },
      {
        :message => "\"Time Auction gave me an excellent opportunity that I couldn't have gotten anywhere else. I really enjoyed it and would do it again! I just wished I had more hours :)\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/rachel.jpg",
        :bidder_name => "Rachel Ong",
        :auction_id => 33
      },
      {
        :message => "\"I really enjoyed meeting Jodi. I never would have known about Jodi's amazing work in mental health and entrepreneurship if it weren't for Time Auction!\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/dan.jpg",
        :bidder_name => "Dan King",
        :auction_id => 18
      },
      {
        :message => "\"Paul gave insightful advice and offered to help me grow my startup through his connections. Plus he was hilarious and down-to-earth. Awesome work Time Auction!\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/andy_chou.jpeg",
        :bidder_name => "Andy Chou",
        :auction_id => 32
      },
      {
        :message => "\"My chat with Sunjay was invaluable and I've already started using what I learned. I love to volunteer, and through Time Auction I was also able to get even more in return!\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/susan.jpg",
        :bidder_name => "Susan Keast",
        :auction_id => 14
      },
      {
        :message => "\"The meeting went beautifully. Jana was gracious and most helpful. It was a pleasure being part of Time Auction and it is nice to know there are people who care about our world. You make us proud!\"",
        :user_avatar => "https://s3-us-west-2.amazonaws.com/timeauction/landing/testimonials/helen_sq.jpg",
        :bidder_name => "H.J. Kovic",
        :auction_id => 28
      }
    ]
  end
end