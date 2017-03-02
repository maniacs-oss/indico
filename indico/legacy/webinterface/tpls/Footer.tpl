<%
if dark is not UNDEFINED:
    dark_ = dark
else:
    dark_ = False;
%>
<div id="footer" class="${"longFooter " if shortURL != "" and not isFrontPage else ""}footer${" footerDark" if dark_ == True else ""} <%block name="footer_classes"></%block>">

% if Config.getInstance().getMobileURL():
    <div class="mobile-footer" style="display:none">
        ${_("Classic")} | <a id="mobileURL" style="font-size:11px !important" href="${Config.getInstance().getMobileURL()}"><span class="icon icon-mobile"></span>${_("Mobile")}</a>
    </div>
     <script type="text/javascript">
         % if conf:
             $("#mobileURL").prop("href", $("#mobileURL").prop("href") + "/event/"+${conf.as_event.id});
             % if conf.as_event.is_protected:
                  $("#mobileURL").prop("href", $("#mobileURL").prop("href") + "?pr=yes");
             % endif
         % endif
         if($.mobileBrowser) {
                $(".mobile-footer").show();
         }
     </script>
% endif
    <%block name="footer">
        <img src="${ systemIcon("indico_small") }" alt="${ _("Indico")}" style="vertical-align: middle; margin-right: 2px;"/>
        <span>${ _("Powered by ")} <a href="http://indico-software.org">Indico</a></span>
        ${ template_hook('page-footer') }
    </%block>
</div>

<div id="outdated">
    <h6>Your browser is out of date!</h6>
    <p>Update your browser to view this website correctly.
    <a id="btnUpdateBrowser" href="http://outdatedbrowser.com/">Update my browser now </a></p>
    <p class="last"><a href="#" id="btnCloseUpdateBrowser" title="Close">&times;</a></p>
</div>
<script>
    $(document).ready(function() {
        outdatedBrowser({
            bgColor: '#0b63a5',
            color: '#ffffff',
            lowerThan: 'IE11',
            languagePath: ''
        });
    })
</script>


% if 'injected_js' in _g:
    ${'\n'.join(_g.injected_js)}
% endif
% if Config.getInstance().getWorkerName():
  <!-- worker: ${ Config.getInstance().getWorkerName() } -->
% endif
% if _app.debug:
  <!-- queries: ${ _g.get('sql_query_count', 0) } -->
  <!-- endpoint: ${ _request.endpoint } -->
  % if rh:
  <!-- rh: ${ rh.__class__.__module__ }.${ rh.__class__.__name__ } -->
  % endif
% endif