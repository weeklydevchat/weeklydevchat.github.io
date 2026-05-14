---
hide:
  - toc
---
# Sponsors

<div class="wdc-sponsors-page" markdown>
  <p class="lead">The Weekly Dev Chat is powered by community members like you!</p>
  <section class="support">
    <div class="support-card">
      <h3>Show Up</h3>
      <p>Attending events is the best way to support the Weekly Dev Chat.  Bring your curiosity and be willing to share your knowledge and learn from others.</p>
    </div>
    <div class="support-card">
      <h3>Spread the Word</h3>
      <p>Invite others who follow our values to an event.  Everyone and anyone is welcome as long as they are kind, supportive, and respectful of others.</p>
    </div>
    <div class="support-card">
      <h3>Sponsor</h3>
      <p>Help keep the lights on and get things done with contributions of money, time, skills, or other resources.  Every little bit helps.</p>
    </div>
  </section>

  <section class="become-sponsor">
    <div class="eyebrow"><span class="dot"></span> Want on this page?</div>
    <div class="become-inner">
      <div>
        <h3>Thank you to our Current and Past Sponsors!</h3>
        <p>Email us if you have any questions or would like to make non-financial contributions.</p>
      </div>
      <div class="become-ctas">
        <a class="btn primary" href="https://buy.stripe.com/dRmaEY4HJ2xUgcG8PdfIs01">Sponsor</a>
        <a class="btn primary" href="mailto:chris@weeklydevchat.com">Email</a>
      </div>
    </div>
  </section>

  {% for year in sponsors.years.keys() | sort(reverse=true) %}
  {% set ids = sponsors.years[year] or [] %}
  <section class="year-group" data-year="{{ year }}">
    <div class="year-header">
      <h2 class="year-num" id="year-{{ year }}">{{ year }}</h2>
      <span class="year-meta">{{ ids|length }} sponsor{{ '' if ids|length == 1 else 's' }} (click/tap for info)</span>
      <div class="year-rule"></div>
    </div>
    <div class="sponsor-grid">
      {% for id in ids %}
        {% if id in sponsors.sponsors %}
          {% set s = sponsors.sponsors[id] %}
          {% set card_links = s.links if s.links else ([{'label': s.link_label or 'Website', 'url': s.link}] if s.link else []) %}
          <div class="sponsor-card" role="button" tabindex="0">
            <div class="card-face card-front">
              <div class="card-logo">
                {% if s.image %}<img src="{{ s.image }}" alt="{{ s.name }}">{% else %}<div class="card-logo-placeholder">{{ s.name[0] }}</div>{% endif %}
              </div>
              <div class="card-footer">
                <span class="card-tier">{{ s.name or 'Sponsor' }}</span>
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
        {% endif %}
      {% endfor %}
    </div>
  </section>
  {% endfor %}

  <dialog id="wdc-sponsor-modal">
    <div class="wdc-sponsor-modal-inner">
      <button class="wdc-sponsor-modal-close" aria-label="Close">&#x2715;</button>
      <div class="wdc-sponsor-modal-tier"></div>
      <h3 class="wdc-sponsor-modal-name"></h3>
      <p class="wdc-sponsor-modal-desc"></p>
      <div class="wdc-sponsor-modal-links"></div>
    </div>
  </dialog>

</div>

<script>
(function () {
  var modal = document.getElementById('wdc-sponsor-modal');
  if (!modal) return;
  var mTier  = modal.querySelector('.wdc-sponsor-modal-tier');
  var mName  = modal.querySelector('.wdc-sponsor-modal-name');
  var mDesc  = modal.querySelector('.wdc-sponsor-modal-desc');
  var mLinks = modal.querySelector('.wdc-sponsor-modal-links');
  var mClose = modal.querySelector('.wdc-sponsor-modal-close');

  function openModal(card) {
    var tier  = card.querySelector('.card-back-tier');
    var name  = card.querySelector('.card-back-name');
    var desc  = card.querySelector('.card-back-desc');
    var links = card.querySelector('.card-back-links');
    mTier.textContent  = tier  ? tier.textContent.trim()  : '';
    mTier.hidden       = !tier;
    mName.textContent  = name  ? name.textContent.trim()  : '';
    mDesc.textContent  = desc  ? desc.textContent.trim()  : '';
    mDesc.hidden       = !desc;
    mLinks.innerHTML   = links ? links.innerHTML           : '';
    mLinks.hidden      = !links;
    modal.showModal();
  }

  document.querySelectorAll('.wdc-sponsors-page .sponsor-card').forEach(function (card) {
    card.addEventListener('click', function () {
      card.blur();
      openModal(card);
    });
    card.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        card.blur();
        openModal(card);
      }
    });
  });

  mClose.addEventListener('click', function () { modal.close(); });
  modal.addEventListener('click', function (e) { if (e.target === modal) modal.close(); });
})();
</script>