---
hide:
  - toc
---
# Help and Sponsorship

The best way you can help the Weekly Dev Chat is to attend the events as the kind, supportive, and respectful person you are. A close second is to share the Weekly Dev Chat with others who might benefit.

We also need volunteers to help with a variety of tasks from helping with events, admin work, website maintenance, social media, etc. If you are interested in volunteering, please reach out to Chris via email at <chris.cumming@saturdaymp.com>.

The final way you can help is by sponsoring SaturdayMP, the main Weekly Dev Chat sponsor, via GitHub [sponsors](https://github.com/sponsors/saturdaymp). Saturday MP pays for Zoom, hosting, food for in real life (IRL) events, and other expenses.

If you have any other ideas for helping Weekly Dev Chat please give [Chris](mailto:chris.cumming@saturdaymp.com) a shout. Thank you for your help and support, it is much appreciated.

{% for year in sponsors.years.keys() | sort(reverse=true) %}
## {{ year }}

### Corporate Sponsors

{% for id in sponsors.years[year].corporate %}
{% if id in sponsors.sponsors %}
{% set s = sponsors.sponsors[id] %}
{% if s.image %}![{{ s.name }}]({{ s.image }}){: style="width:150px;float: left;padding-right: 10px;"}
{% endif %}
**{% if s.link %}[{{ s.name }}]({{ s.link }}){% else %}{{ s.name }}{% endif %}**

{% if s.description %}{{ s.description }}{% endif %}

<div style="clear: both;"></div>

{% else %}
> **WARNING:** Unknown sponsor ID `{{ id }}` referenced in `{{ year }}` corporate list. Check `data/sponsors.yml` for a typo.

{% endif %}
{% endfor %}

{% if sponsors.years[year].individual %}
### Individual Donors

{% for id in sponsors.years[year].individual %}
{% if id in sponsors.sponsors %}
{% set s = sponsors.sponsors[id] %}
{% if s.image %}![{{ s.name }}]({{ s.image }}){: style="width:150px;float: left;padding-right: 10px;"}
{% endif %}
**{% if s.link %}[{{ s.name }}]({{ s.link }}){% else %}{{ s.name }}{% endif %}**

{% if s.description %}{{ s.description }}{% endif %}

<div style="clear: both;"></div>

{% else %}
> **WARNING:** Unknown donor ID `{{ id }}` referenced in `{{ year }}` individual list. Check `data/sponsors.yml` for a typo.

{% endif %}
{% endfor %}
{% endif %}
{% endfor %}
