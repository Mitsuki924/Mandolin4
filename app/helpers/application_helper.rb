module ApplicationHelper
  # YouTube URLから動画IDを抽出するメソッド
  def find_youtube_url(url)
    return "" if url.blank?
    if url.include?("youtu.be/")
      url.split("youtu.be/").last.split("?").first
    elsif url.include?("watch?v=")
      url.split("watch?v=").last.split("&").first
    else
      url
    end
  end

  # 🎼 プログラムの各行に「活版ドロップキャップ章扉 ＆ ドットリーダー線 ＆ 動画検索リンク」を付与するヘルパー
  def render_program_with_links(text)
    return "" if text.blank?

    lines = text.split("\n")
    formatted_lines = lines.map do |line|
      stripped = line.strip

      # 空行
      next '<div style="height: 12px;"></div>' if stripped.blank?

      # 見出し判定（部・ステージ・アンコール・Part・Stageなど）
      if stripped.match?(/^(第?[0-9０-９一二三四五六七八九十]+部|【|■|◾︎|◆|◇|ステージ|部|アンコール|Stage|Part|Act)/i)
        clean_heading = stripped.gsub(/[【】■◾︎◆◇]/, "").strip
        
        # ローマ数字や章タイトルの抽出
        roman_num = ""
        stage_label = "STAGE"
        
        if clean_heading =~ /第?([1１一])部?/
          roman_num = "I"
          stage_label = "PART I"
        elsif clean_heading =~ /第?([2２二])部?/
          roman_num = "II"
          stage_label = "PART II"
        elsif clean_heading =~ /第?([3３三])部?/
          roman_num = "III"
          stage_label = "PART III"
        elsif clean_heading =~ /第?([4４四])部?/
          roman_num = "IV"
          stage_label = "PART IV"
        elsif clean_heading =~ /アンコール|Encore/i
          roman_num = "E"
          stage_label = "ENCORE"
        else
          roman_num = clean_heading[0..1].upcase
          stage_label = "SECTION"
        end

        <<~HTML.html_safe
          <div class="stage-chapter-heading">
            <div class="stage-drop-cap">#{ERB::Util.html_escape(roman_num)}</div>
            <div class="stage-heading-text">
              <span class="stage-subtitle font-cinzel">#{ERB::Util.html_escape(stage_label)}</span>
              <h4 class="stage-title font-serif-title">#{ERB::Util.html_escape(clean_heading)}</h4>
            </div>
          </div>
        HTML
      else
        title_part = stripped
        composer_part = ""

        if stripped.include?("／")
          parts = stripped.split("／", 2)
          title_part, composer_part = parts[0].strip, parts[1].strip
        elsif stripped.include?(" / ")
          parts = stripped.split(" / ", 2)
          title_part, composer_part = parts[0].strip, parts[1].strip
        elsif stripped.match(/(.+?)([\(（]作曲[：:].+[\)）]|[\(（].+?作曲[\)）]|作曲[：:].+)/)
          m = stripped.match(/(.+?)([\(（]作曲[：:].+[\)）]|[\(（].+?作曲[\)）]|作曲[：:].+)/)
          title_part, composer_part = m[1].strip, m[2].strip
        end

        clean_title = title_part.gsub(/[「」『』"']/, "").strip
        search_query = CGI.escape("#{clean_title} マンドリン")
        youtube_search_url = "https://www.youtube.com/results?search_query=#{search_query}"

        link_html = link_to("動画 ↗", youtube_search_url, target: "_blank", rel: "noopener noreferrer", class: "program-video-badge")

        <<~HTML.html_safe
          <div class="program-item">
            <span class="program-title">#{ERB::Util.html_escape(title_part)}</span>
            <span class="dot-leader"></span>
            <span class="program-meta">
              #{ERB::Util.html_escape(composer_part) if composer_part.present?}
              #{link_html}
            </span>
          </div>
        HTML
      end
    end

    formatted_lines.join("\n").html_safe
  end

  # 📚 書誌インデックス調パンくずリスト
  def render_breadcrumbs(items = [])
    return "" if items.blank?

    content_tag(:nav, class: "classic-breadcrumbs", style: "max-width: 1040px; margin: 15px auto 0 auto; padding: 0 10px; font-size: 11.5px;") do
      items.map.with_index do |(label, path), idx|
        is_last = (idx == items.size - 1)
        separator = is_last ? "" : '<span style="margin: 0 8px; color: #a8a29e; font-size: 10px;">/</span>'.html_safe

        if path.present? && !is_last
          link_to(label, path, class: "font-cinzel gold-underline-dark", style: "color: #78716c; text-decoration: none; letter-spacing: 1px; font-weight: 600;") + separator
        else
          content_tag(:span, label, class: "font-serif-title", style: "color: #0f172a; font-weight: 600; letter-spacing: 0.5px;")
        end
      end.join.html_safe
    end
  end
end