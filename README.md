# Copy Across Data Layers #

This template lets you copy across events from one dataLayer to another, regardless of which dataLayer object you are using with your GTM instance.
There are a few different use cases where this could be useful:
- If certain partners/CMPs/platforms write to the default dataLayer but that isn't the one you are using on GTM.
- Using different dataLayers for different analytics or advertising partners.
- Debugging specific events by copying them to a less-cluttered dataLayer object where it is easier to find and view the values.
- Augment copies of dataLayer events, rather than editing the primary event.

The events copied over will have a key value added of *event_copy: true* 

To use the template:
1. Download the template.tpl file
2. Import it into a web GTM container
3. Create a new tag using this template
4. Fill in the fields:
   - Name of data layer you want to copy from
   - Name of data layer you want to copy to
   - List of events top copy (*one event name as it appears in the data layer per row*)
5. Add a trigger of your choice, such as Consent Initialisation or Page View, whatever makes the most sense for your use.

Let me know if you encounter any bugs!
