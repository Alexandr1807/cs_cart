<div id="product_features_{$block.block_id}">
<div class="ty-feature">
    {if $department_data.main_pair}
        <div class="ty-feature__image">
            {include file="common/image.tpl" images=$department_data.main_pair}
        </div>
    {/if}
    <div class="ty-feature__description ty-wysiwyg-content">
        {$department_data.description nofilter}
    </div>
</div>
<div>
    <h2>Сотрудники отдела</h2>
    {foreach from=$department_data.users_ids item=v}
        <div>
            <p>
                <b>{$v.firstname}</b>
                <b>{$v.lastname} <a href="mailto:{$v.email}">({$v.email})</a></b>
            </p>
        </div>
    {/foreach}
</div>

<!--product_features_{$block.block_id}--></div>
{capture name="mainbox_title"}{$department_data.department nofilter}{/capture}