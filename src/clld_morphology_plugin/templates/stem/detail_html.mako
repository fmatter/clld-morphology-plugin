<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<% from clld_morphology_plugin.util import rendered_form %>
<% from clld_morphology_plugin.util import render_derived_from %>
<% from clld_morphology_plugin.util import render_derived_stems %>
<% from clld_morphology_plugin.models import Wordform %>
<%! active_menu_item = "stems" %>

<h3>${_('Stem')} <i>${ctx.name}</i> ‘${ctx.description}’</h3>

<table class="table table-nonfluid">
    <tbody>
        <tr>
            <td>Language:</td>
            <td>${h.link(request, ctx.language)}</td>
        </tr>
        % if ctx.lexeme:
            <tr>
                <td> Lexeme: </td>
                <td> ${h.link(request, ctx.lexeme)}</td>
            </tr>        
        % endif
        % if ctx.glosses:
            <tr>
                <td> Gloss: </td>
                <td> ${h.text2html(", ".join([h.link(request, g) for g in ctx.glosses]))}</td>
            </tr>        
        % endif
        % if ctx.parts:
            <tr>
                <td> Structure: </td>
                <td>
                    ${rendered_form(request, ctx) | n}<br>
                    ${rendered_form(request, ctx, line="gloss") | n}<br>
                    ## ${rendered_form(request, ctx, level="stem") | n}<br>
                    ## ${rendered_form(request, ctx, level="stem", line="gloss") | n}
                </td>
            </tr>
        % endif
        % if ctx.derived_from:
            <tr>
                <td> ${_('Derivational lineage')}: </td>
                <td>
                    ${render_derived_from(request, ctx) | n}
                </td>
            </tr>
        % endif
        % if ctx.derivations:
            <tr>
                <td> ${_('Derived stems')}: </td>
                <td>
                    ${render_derived_stems(request, ctx)}
                </td>
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

% if ctx.stemforms:
    <h4>${_('Wordforms')}:</h4>
    ${request.get_datatable('wordforms', Wordform, stem=ctx).render()}
% endif