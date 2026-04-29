---
hide:
  - toc
---
# Contribute

<div class="wdc-sponsors-page" markdown>
  <p class="lead">Like the Weekly Dev Chat and want to help?</p>
  <section class="support">
    <div class="support-card">
      <h3>Show Up</h3>
      <p>Attending events is the best way to support the Weekly Dev Chat.  Bring your curiousity and be willing to share your knowledge and learn from others.</p>
    </div>
    <div class="support-card">
      <h3>Spread the Word</h3>
      <p>Invite people who follow our values to our events.  Everyone and anyone is welcome kind, supportive, and respectful of others.</p>
    </div>
    <div class="support-card">
      <h3>Sponsor</h3>
      <p>Help keep the lights and get things done with contributions of money, time, skills, or other resources.  Every little bit helps.</p>
    </div>
  </section>

  <section class="become-sponsor">
    <div class="become-inner">
      <div>
        <div class="eyebrow"><span class="dot"></span> Want on this page?</div>
        <h3>Contribute to Weekly Dev Chat</h3>
        <p>Any amount helps cover Zoom, hosting, and the occasional IRL pizza. Sponsor Saturday MP and you'll be listed under this year's supporters.</p>
      </div>
      <div class="become-ctas">
        <a class="btn primary" href="https://github.com/sponsors/saturdaymp" target="_blank" rel="noopener">Sponsor on GitHub</a>
        <a class="btn ghost" href="mailto:chris.cumming@saturdaymp.com">Email Chris</a>
      </div>
    </div>
  </section>

  Thanks to our current and past supporters!

  {% for year in sponsors.years.keys() | sort(reverse=true) %}
  {% set ids = (sponsors.years[year].corporate or []) + (sponsors.years[year].individual or []) %}
  <section class="year-group" data-year="{{ year }}">
    <div class="year-header">
      <h2 class="year-num" id="year-{{ year }}">{{ year }}</h2>
      <span class="year-meta">{{ ids|length }} sponsor{{ '' if ids|length == 1 else 's' }}</span>
      <div class="year-rule"></div>
    </div>
    <div class="sponsor-grid">
      {% for id in ids %}
        {% if id in sponsors.sponsors %}
          {% set s = sponsors.sponsors[id] %}
          {% set card_links = s.links if s.links else ([{'label': s.link_label or 'Website', 'url': s.link}] if s.link else []) %}
          <div class="sponsor-card" tabindex="0">
            <div class="card-face card-front">
              <div class="card-logo">
                {% if s.image %}<img src="{{ s.image }}" alt="{{ s.name }}">{% else %}<div class="card-logo-placeholder">{{ s.name[0] }}</div>{% endif %}
              </div>
              <div class="card-footer">
                <span class="card-tier">{{ s.tier or 'Sponsor' }}</span>
                <span class="card-hint">hover for info</span>
              </div>
            </div>
            <div class="card-face card-back">
              <div class="card-back-inner">
                {% if s.tier %}<div class="card-back-tier">{{ s.tier }}</div>{% endif %}
                <h4 class="card-back-name">{{ s.name }}</h4>
                {% if s.description %}<p class="card-back-desc">{{ s.description }}</p>{% endif %}
                {% if card_links %}
                  <div class="card-back-links">
                    {% for l in card_links %}
                      <a href="{{ l.url }}" target="_blank" rel="noopener">{{ l.label }} <span class="arrow">↗</span></a>
                    {% endfor %}
                  </div>
                {% endif %}
              </div>
            </div>
          </div>
        {% else %}
  > **WARNING:** Unknown sponsor ID `{{ id }}` referenced in `{{ year }}`. Check `data/sponsors.yml` for a typo.
        {% endif %}
      {% endfor %}
    </div>
  </section>
  {% endfor %}

</div>
