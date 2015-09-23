namespace :dev do


  task event: :environment do



  agent = Mechanize.new
  agent.user_agent_alias = 'Mac Safari'

  (268050..272966).each do |event_number|

    puts "#{event_number} start"

    puts "#{event_number} get page"
    page = agent.get("http://www.citytalk.tw/event/#{event_number}")

    puts "#{event_number} get url"
    url = agent.get("http://www.citytalk.tw/sys/redirector.php?from=event&e_id=#{event_number}")



    next if page.search('.site-breadcrumb .active').text == '找不到活動'


    event_title = page.search('h1').text

    event_start_time = page.at('.info-box li .row div:nth-child(2) meta')['content']

    event_end_time = page.at('.info-box li .row div:nth-child(2) meta:nth-child(2)')['content']

    event_address = page.at('.info-box li:nth-child(2) .row div:nth-child(2)').text
    event_address.slice! "(地圖)"

    event_price = page.at('.info-box li:nth-child(3) .row div:nth-child(2)').text

    event_session = page.at('.info-box li:nth-child(4) .row div:nth-child(2)').text

    # event_hoster = page.at('.info-box .info-meta-box:nth-child(2) li .row div:nth-child(2)').text

    event_url = url.at('.redirect-box input')['value']

    # event_tel = page.at('.info-box .info-meta-box:nth-child(2) li:nth-child(3) .row div:nth-child(2)').text

    event_pic = page.at('.pic-box img')['data-original']

    puts "#{event_number} create event"

    begin
      event = Event.create(:title => event_title, :address => event_address , :start_time => event_start_time ,
                        :end_time => event_end_time , :website => event_url , :type_cd => event_session ,
                        :citytalk_price => event_price , :cover => 'http://www.citytalk.tw' + event_pic )
    rescue Exception => e
      puts e.message
    end

    # event.address.slice! "(地圖)"

    # event.save

    puts "========== #{event_number} end ========="





    # sleep 3

    # puts event_price

    # puts event_session

    # puts event_hoster

    # puts event_url

    # puts event_tel

      # event = Event.new( :title => title , :address => info.text , :organizer => 'test' )

      # puts info

      # event.save

      # puts 'ok'



    end

 end

end