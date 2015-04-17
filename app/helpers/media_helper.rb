module MediaHelper
  def logos
    return {
      "cbc" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/cbc_logo.png",
      "24hrs" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/vancouver_24hrs.png",
      "ctv" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/ctv_logo.png",
      "metro" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/metro_logo.png",
      "yahoo" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/yahoo_logo.png",
      "msn" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/msn_logo.png",
      "sauder" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/sauder.png",
      "city" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/city_logo.png",
      "vancouver_sun" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/vancouver_sun_logo.png",
      "680" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/680_logo.png",
      "gnt" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/gnt.png",
      "winnipeg_free_press" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/winnipeg_logo.png",
      "getinvolved" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/getinvolved.png",
      "goodnet" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/goodnet.png",
      "liverightnow" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/liverightnow.png",
      "qsb" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/qsb.png"
    }
    # "province" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/province_logo.png",
    # "chronicle_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/chronicle_logo.png",
    # "calgary_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/calgary_herald_logo.png",
  end

  def popular_logos
    return [
      logos["cbc"],
      logos["ctv"],
      logos["metro"],
      logos["yahoo"]
    ]
  end

  def links
    return {
      "cbc" => "http://www.cbc.ca/news/canada/hamilton/news/why-tim-hortons-co-founder-ron-joyce-is-ready-to-meet-with-you-1.2583951",
      "ctv" => "http://www.ctvnews.ca/sci-tech/want-to-meet-the-co-founder-of-tim-hortons-try-volunteering-1.1742124",
      "msn" => "http://tech.ca.msn.com/volunteering-website-trades-hours-for-prizes-1",
      "24hrs" => "http://vancouver.24hrs.ca/2015/03/10/auction-matches-volunteers-with-celebs",
      "metro" => "http://metronews.ca/news/canada/980426/volunteering-website-trades-hours-for-prizes",
      "sauder" => "http://www.sauder.ubc.ca/News/2015/Bid_volunteer_hours_to_meet_inspiring_people",
      "yahoo" => "http://ca.news.yahoo.com/want-meet-tim-hortons-co-founder-volunteer-website-140012221.html",
      "city" => "http://www.citynews.ca/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "vancouver_sun" => "http://www.vancouversun.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours+meetings/9651404/story.html#757Live",
      "680" => "http://www.680news.com/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "gnt" => "http://www.goodnewstoronto.ca/2014/11/time-is-money/",
      "winnipeg_free_press" => "http://www.winnipegfreepress.com/canada/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings-251777231.html",
      "getinvolved" => "https://www.getinvolved.ca/2014/06/convert-volunteer-hours-jumpstart-career-rev-rev/",
      "goodnet" => "http://www.goodnet.org/articles/time-more-valuable-than-money-at-this-good-doing-auction-site",
      "liverightnow" => "http://www.cbc.ca/liverightnow/tips-and-articles/getting-started/new-benefit-of-volunteering.html",
      "qsb" => "http://qsb.ca/magazine/summer-2014/features/start-ups-snapshot"
    }
    # "chronicle_herald" => "http://thechronicleherald.ca/artslife/1195357-website-lets-you-pay-with-volunteer-hours-to-meet-someone-cool",
    # "calgary_herald" => "http://www.calgaryherald.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours/9651404/story.html",
  end

  def news
    return [
      "cbc",
      "24hrs",
      "ctv",
      "metro",
      "qsb",
      "msn",
      "sauder",
      "yahoo",
      "city",
      "vancouver_sun",
      "680",
      "gnt",
      "liverightnow",
      "goodnet",
      "getinvolved",
      "winnipeg_free_press"
    ]
    # "chronicle_herald",
    # "calgary_herald",
  end
end