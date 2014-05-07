module ApplicationHelper
  def pool(coin)
    @flattened_pool_data.find { |pool| pool.coin.downcase == coin.downcase }
  end

  def time_since_last_block(coin)
    pool = pool(coin)
    pool.try(:time_since_last_block) || [0, 0]
  end

  def arrows(algo)
    older = Hashie::Mash[@display_data[1]].public_send(algo)
    latest = @latest_display_data.public_send(algo)

    [
      latest.hash_rate > older.hash_rate,
      latest.best_hash_rate_value > older.best_hash_rate_value,
      latest.workers > older.workers,
      latest.most_workers_value > older.most_workers_value
    ].map do |cond|
      cond ? "fa-caret-up color-green" : "fa-caret-down color-red"
    end
  end

  def coin_link(coin)
    link_to "#{chunky_url}#{coin}" do
      yield
    end
  end



  # <li><a href="/contact"><i class="fa fa-inbox"></i> Contact</a></li>
  def nav_item(text, link, icon, active_condition = nil)
    active = { class: 'active' } if active_condition && content_for(:page) == active_condition
    content_tag(:li, active) do
      link_to(content_tag(:i, nil, class: "fa fa-#{icon}") + ' ' + text, link)
    end
  end

  def nav_spacer
    content_tag(:li) { raw("&nbsp;") }
  end
end
