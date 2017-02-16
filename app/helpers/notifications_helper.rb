module NotificationsHelper
  # 作成時刻を通知用に日本用に変更して表示する
  def posted_time(time)
    time > Date.today ? "#{time_ago_in_words(time)}" : time.strftime('%m月%d日')
  end
  #　値によって既読か未読かを表示させる
  def read_status(read)
    if read==false
      "未読"
    else
      "既読"
    end
  end
end
