class PagesController < ApplicationController
  def landing
    @featured_auctions = Auction.where(:featured => true).sample(3)
  end

  def donors
    @sample_auction_1 = Auction.find(15)
    @sample_auction_2 = Auction.find(16)
    @sample_auction_3 = Auction.find(8)
  end

  def media
    @links = {
      "cbc" => "http://www.cbc.ca/news/canada/hamilton/news/why-tim-hortons-co-founder-ron-joyce-is-ready-to-meet-with-you-1.2583951",
      "ctv" => "http://www.ctvnews.ca/sci-tech/want-to-meet-the-co-founder-of-tim-hortons-try-volunteering-1.1742124",
      "msn" => "http://tech.ca.msn.com/volunteering-website-trades-hours-for-prizes-1",
      "metro" => "http://metronews.ca/news/canada/980426/volunteering-website-trades-hours-for-prizes",
      "province" => "http://www.theprovince.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours+meetings/9651404/story.html",
      "chronicle_herald" => "http://thechronicleherald.ca/artslife/1195357-website-lets-you-pay-with-volunteer-hours-to-meet-someone-cool",
      "yahoo" => "http://ca.news.yahoo.com/want-meet-tim-hortons-co-founder-volunteer-website-140012221.html",
      "city" => "http://www.citynews.ca/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "vancouver_sun" => "http://www.vancouversun.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours+meetings/9651404/story.html#757Live",
      "680" => "http://www.680news.com/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "calgary_herald" => "http://www.calgaryherald.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours/9651404/story.html",
      "winnipeg_free_press" => "http://www.winnipegfreepress.com/canada/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings-251777231.html"
    }

    @logos = {
      "cbc" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/cbc_logo.png",
      "ctv" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/ctv_logo.png",
      "msn" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/msn_logo.png",
      "metro" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/metro_logo.png",
      "province" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/province_logo.png",
      "chronicle_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/chronicle_logo.png",
      "yahoo" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/yahoo_logo.png",
      "city" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/city_logo.png",
      "vancouver_sun" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/vancouver_sun_logo.png",
      "680" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/680_logo.png",
      "calgary_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/calgary_herald_logo.png",
      "winnipeg_free_press" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/winnipeg_logo.png"
    }

    @news = [
      "cbc",
      "ctv",
      "msn",
      "metro",
      "province",
      "chronicle_herald",
      "yahoo",
      "city",
      "vancouver_sun",
      "680",
      "calgary_herald",
      "winnipeg_free_press"
    ]

    @tweets = [
      "<p>National Volunteer Week is fast approaching (Apr. 6-12). This is a great initiative to promote volunteerism in Canada <a href='http://t.co/vWPzlbQuco'>http://t.co/vWPzlbQuco</a></p>&mdash; Paul Miller (@PaulMillerMPP) <a href='https://twitter.com/PaulMillerMPP/statuses/448458981900812288'>March 25, 2014</a>",
      "<p>Time Auction is a unique way to use volunteer hours to bid on opportunities to meet with industry professionals. <a href='http://t.co/xHNJCOlKDw'>http://t.co/xHNJCOlKDw</a></p>&mdash; Volunteer Toronto (@VolunteerTO) <a href='https://twitter.com/VolunteerTO/statuses/448897499408121856'>March 26, 2014</a>",
      "<p>Very cool startup idea: volunteer your time &amp; meet cool ppl as a prize! <a href='https://twitter.com/Dawenster'>@dawenster</a> <a href='http://t.co/U7krSuYE5S'>http://t.co/U7krSuYE5S</a> <a href='https://twitter.com/search?q=%23tech&amp;src=hash'>#tech</a></p>&mdash; Suzanne Ma (@suzannebma) <a href='https://twitter.com/suzannebma/statuses/448186421208047616'>March 24, 2014</a>",
      "<p>Want to meet Tim Hortons co-founder? Volunteer website Time Auction trades hours for meetings <a href='http://t.co/frUdpSmPmz'>http://t.co/frUdpSmPmz</a> <a href='https://twitter.com/search?q=%23cdntech&amp;src=hash'>#cdntech</a></p>&mdash; Michael Oliveira (@michaeloliveira) <a href='https://twitter.com/michaeloliveira/statuses/448112213845635072'>March 24, 2014</a>"
    ]
  end
end