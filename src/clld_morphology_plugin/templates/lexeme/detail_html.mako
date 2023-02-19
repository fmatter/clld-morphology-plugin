<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<% from clld_morphology_plugin.models import Wordform %>
<% from clld_morphology_plugin.util import get_further_lexemes %>
<% from clld_morphology_plugin.util import render_paradigm %>
<% from clld_morphology_plugin.util import rendered_form %>
<%! active_menu_item = "lexemes" %>

<h3>${_('Lexeme')} <i>${ctx.name}</i> ‘${ctx.description}’</h3>

<table class="table table-nonfluid">
    <tbody>
            <tr>
                <td> Language: </td>
                <td> ${h.link(request, ctx.language)}</td>
            </tr> 
        % if ctx.stems:
            <tr>
                <td> Stems: </td>
                <td> ${h.text2html(", ".join([h.link(request, stem) for stem in ctx.stems]))}</td>
            </tr>        
        % endif
    </tbody>
</table>


<%def name="print_cell(entity)">
    % if isinstance(entity, str):
        ${entity}
    % else:
        ${h.link(request, entity)}
    % endif
</%def>

Inflected forms:
<% paradigm = render_paradigm(ctx) %>
<table border="1">
    % for col_idx, colname in enumerate(paradigm["colnames"]):
        <tr>
            % for x in range(len(paradigm["idxnames"])-1):
                <td> </td>
            % endfor
            <th> ${h.link(request, colname)} </th>
            % for column in paradigm["columns"]:
                <th> ${print_cell(column[col_idx])} </th>
            % endfor
        </tr>
    % endfor
    <tr>
        % for idxname in paradigm["idxnames"]:
            <th>
                ${print_cell(idxname)}
            </th>
        % endfor
    </tr>
        <tr>
        % for idxnames, cells in zip(paradigm["index"], paradigm["cells"]):
        <tr>
            % for idxname in idxnames:
            <th>
                ${print_cell(idxname)}
                </th>
            % endfor
            % for cell in cells:
            <td>
                % for form in cell:
                    <i>${rendered_form(request, form, level="wordforms") | n}</i> <br>
                % endfor
                </td>
            % endfor
        </tr>
        % endfor
    </tr>
 </table>
    ## ${render_paradigm(ctx, html=True) | n}
##  <select  class="select control input-small" name="View" id="wf-mode">
##     <option value="stem">stems</option>
##     <option value="morphemes">morphemes</option>
## </select>

##  <select  class="select control input-small" name="View" id="wmode">
##     <option value="wordforms">wordforms</option>
##     <option value="forms">forms</option>
##     <option value="morphemes">morphemes</option>
## </select>
<dl>

<h4>${_('Forms')}:</h4>
${request.get_datatable('wordforms', Wordform, lexeme=ctx, language=ctx.language).render()}