from buildbot.status.web.base import HtmlResource
import buildbot
import twisted
import sys
import jinja2

class Dailybuild(HtmlResource):
    pageTitle = "About this Buildbot"

    def content(self, request, cxt):
        cxt.update(dict(buildbot=buildbot.version, 
                               twisted=twisted.__version__,
                               jinja=jinja2.__version__, 
                               python=sys.version,
                               platform=sys.platform))

        template = request.site.buildbot_service.templates.get_template("dailybuild.html")
        template.autoescape = True
        return template.render(**cxt)

