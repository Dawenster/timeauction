class PagesController < ApplicationController
  def landing
    @featured_auctions = Auction.where(:featured => true).sample(3)
  end

  def donors
    @sample_auction_1 = Auction.find_by_id(15)
    @sample_auction_2 = Auction.find_by_id(16)
    @sample_auction_3 = Auction.find_by_id(8)
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
      "<p>Time Auction is a unique way to use volunteer hours to bid on opportunities to meet with industry professionals. <a href='http://t.co/xHNJCOlKDw'>http://t.co/xHNJCOlKDw</a></p>&mdash; Volunteer Toronto (@VolunteerTO) <a href='https://twitter.com/VolunteerTO/statuses/448897499408121856'>March 26, 2014</a>",
      "<p>National Volunteer Week is fast approaching (Apr. 6-12). This is a great initiative to promote volunteerism in Canada <a href='http://t.co/vWPzlbQuco'>http://t.co/vWPzlbQuco</a></p>&mdash; Paul Miller (@PaulMillerMPP) <a href='https://twitter.com/PaulMillerMPP/statuses/448458981900812288'>March 25, 2014</a>",
      "<p><a href='http://t.co/13CiOQItZr'>http://t.co/13CiOQItZr</a> Such a cool idea! Exchange volunteer hours for a lunch date with an impressive executive!</p>&mdash; Maria Habanikova (@MariaSK88) <a href='https://twitter.com/MariaSK88/statuses/449183119326060545'>March 27, 2014</a>",
      "<p>Very cool. Who would you want to meet? <a href='https://twitter.com/search?q=%23timeauction&amp;src=hash'>#timeauction</a> <a href='http://t.co/Jk7PCKUc1x'>http://t.co/Jk7PCKUc1x</a></p>&mdash; Jacquie Stoyek (@j_stoyek) <a href='https://twitter.com/j_stoyek/statuses/447927450828558336'>March 24, 2014</a>",
      "<p>Just bid on: &#39;Meet the Editor-in-Chief of the Toronto Star - Michael Cooke&#39;! <a href='http://t.co/RUIrRYrQoH'>http://t.co/RUIrRYrQoH</a> <a href='https://twitter.com/search?q=%23timeauction&amp;src=hash'>#timeauction</a> <a href='https://twitter.com/search?q=%23moneycantbuy&amp;src=hash'>#moneycantbuy</a></p>&mdash; ADVAANA (@ADVAANA) <a href='https://twitter.com/ADVAANA/statuses/447832183625879552'>March 23, 2014</a>",
      "<p>Neat idea. TimeAuction, get experience rewards in exchange for volunteer hours: <a href='http://t.co/67rebbS9Da'>http://t.co/67rebbS9Da</a></p>&mdash; Chuck Bergeron (@ChuckBergeron) <a href='https://twitter.com/ChuckBergeron/statuses/439483595825373184'>February 28, 2014</a>"

    ]
  end
end