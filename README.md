# Copy Across Data Layers #

This template lets you copy across events from one dataLayer to another, regardless of which dataLayer object you are using with your GTM instance.
There are a few different use cases where this could be useful:
- If certain partners/platforms write to the default dataLayer but that isn't the one you are using on GTM. For example OneTrustGroupsUpdated which used the default dataLayer.
- Using different dataLayers for different analytics or advertising partners.
- Debugging specific events by copying them to a less-cluttered dataLayer object where it is easier to find and view the values.
- Augment copies of dataLayer events, rather than editing the primary event.

The events copied over will have a key value added of *event_copy: true* 

To use the template:
1. Download the template.tpl file
2. Go to Templates within GTM and select new
3. Click the top right menu and select Import
4. Import the template.tpl file
5. Adjust the permissions tags with the names of your data layer objects for it to access (currently instantiated with some dummy values)
6. Create a new tag with this template
7. Fill in the fields:
   - Name of data layer you want to copy from
   - Name of data layer you want to copy to
   - List of events top copy (*one event name as it appears in the data layer per row*)
8. Add a trigger, such as Consent Initialisation or Page View, whatever makes the most sense for your use.

Let me know if you encounter any bugs!
