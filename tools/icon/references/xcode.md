# Xcode App Icon Reference

<!--
{
  "documentType" : "article",
  "framework" : "Xcode",
  "identifier" : "/documentation/Xcode/creating-your-app-icon-using-icon-composer",
  "metadataVersion" : "0.1.0",
  "role" : "article",
  "title" : "Creating your app icon using Icon Composer"
}
-->

## Creating your app icon using Icon Composer
<!-- https://developer.apple.com/tutorials/data/documentation/xcode/creating-your-app-icon-using-icon-composer.md -->
Use Icon Composer to stylize your app icon for different platforms and appearances.

## Overview

Use Icon Composer to create a single multilayer file that you can add to your Xcode project to represent your Liquid Glass app icon everywhere your app icon appears across iOS, iPadOS, macOS, watchOS, and the App Store. Use your favorite design tool to create the artwork for your app icon, but save some design decisions for Icon Composer, where you can refine the dynamic properties of [Liquid Glass](doc://com.apple.documentation/documentation/TechnologyOverviews/liquid-glass) and customize variants of your app icon for different platforms and appearances.

![A screenshot of Icon Composer that shows a group selected in the sidebar, iOS, macOS platform and mono appearance selected in the canvas, and Liquid Glass settings in the Style inspector. The canvas shows the icon over a custom background image with 50% blur and translucency Liquid Glass settings.](images/com.apple.Xcode/icon-composer-hero-overview@2x.png)

Before building your app, add the Icon Composer file to your Xcode project to include it in your app’s bundle. The system automatically renders your app icon for the different platforms, appearances, and sizes from your single Icon Composer file. If your app supports previous releases (in the Minimum Deployments settings in the target’s General pane) that don’t have the same icon and widget style appearances and Liquid Glass material, Xcode automatically generates app icon images at build time for those releases from the Icon Composer file.

> Important: If you add an Icon Composer file to your Xcode project, it replaces any existing icon asset catalog that you previously used to represent your app icon. Xcode automatically generates a similar-looking version of the Liquid Glass icon for previous releases. If you want your existing icon to appear in previous releases, continue to use asset catalogs to represent your app icon.

To learn more, see the following resources:

- For guidance on designing your app icon, see [Human Interface Guidelines > Foundations > App icons](doc://com.apple.documentation/design/Human-Interface-Guidelines/app-icons).
- For converting older app icons to use the Liquid Glass material, see [Adopting Liquid Glass > App icons](doc://com.apple.documentation/documentation/TechnologyOverviews/adopting-liquid-glass).
- For more information on Liquid Glass and Icon Composer, watch [Say hello to the new look of app icons](https://developer.apple.com/videos/play/wwdc2025/220/) and [Create icons with Icon Composer](https://developer.apple.com/videos/play/wwdc2025/361/).
- For tvOS and visionOS targets that still use an `AppIcon` asset catalog, see [Configuring your app icon using an asset catalog](/documentation/Xcode/configuring-your-app-icon).

## Prepare your artwork for export

To design your Liquid Glass app icon, use a third-party vector graphics editor of your choice that exports your layers as graphic files in SVG or PNG format. To give you the most scalability, use vector graphics to draw shapes and export SVG files.

While you design your app icon and before you export layers, follow these guidelines for best results:

- Start with an app icon template that you download from [Apple Design Resources](https://developer.apple.com/design/resources/) that has the latest grid, shape, and canvas size.
- Otherwise, change the canvas size to match the size that you use in Icon Composer, such as 1024 x 1024 pixels for iPhone, iPad, and Mac, and 1088 x 1088 pixels for Apple Watch.
- Design your app icon in layers that the system renders in the z-plane from back to front.
- Separate colors, text, and any other graphics into layers that you want to modify for platforms and appearances in Icon Composer.
- Because SVG format doesn’t preserve fonts, convert text to outlines.
- Give the layers meaningful names that include numbers (increment from back to front) to help you organize them in Icon Composer.

In addition, wait to apply some effects in Icon Composer where you can preview and adjust them for Liquid Glass:

- Remove blurs and shadows, and specular, opacity, and translucency settings.
- Remove background colors and gradients.

When you’re ready to export layers from your third-party tool, choose the SVG format whenever possible. For layers that contain unsupported SVG features, choose PNG or another raster image format that Icon Composer supports. Don’t export the canvas mask because the system applies that automatically to ensure a perfect crop.

## Create your Icon Composer file

To launch Icon Composer in the latest version of Xcode, choose Xcode > Open Developer Tool > Icon Composer. If you don’t install Xcode, go to [Icon Composer](https://developer.apple.com/icon-composer) to download it instead.

Icon Composer shows a default app icon with a solid background color. Give the file a name that you want to use later in the Xcode project, such as `AppIcon`. Choose File > Save and in the dialog that appears, enter the filename and click Save. Alternatively, click `Untitled` in the toolbar and change the name and location in the dialog that appears.

![A screenshot of Icon Composer with callouts showing the groups and layers for the Landmarks sample app in the sidebar, the iOS, macOS platform and default appearance selected in the canvas, and the settings for a group in the Style inspector.](images/com.apple.Xcode/icon-composer-app-anatomy@2x.png)

You use the sidebar on the left to organize layers into groups, the canvas in the middle to preview variants, and the inspectors on the right to modify appearances. In the canvas area, you use the controls at the bottom to select combinations of platforms and appearances, and the controls at the top to apply a grid or simulate device conditions.

You can continue using Icon Composer to fine-tune your app icon and add it to your Xcode project later. To add your app icon to an Xcode project and associate it with your app target, see [Add your Icon Composer file to an Xcode project](/documentation/Xcode/creating-your-app-icon-using-icon-composer#Add-your-Icon-Composer-file-to-an-Xcode-project).

If your Icon Composer file is in your Xcode project, you can select it in the Project navigator and see a preview in the canvas area. To open an Icon Composer file that’s in your Xcode project, click Open with Icon Composer under the preview, or Control-click the file in the Project navigator and choose Open with External Editor.

## Import your graphic files

After you export your artwork from your design tool, import the graphic files, in SVG or PNG format, into your Icon Composer file.

Drag one or more graphic files from the Finder to the sidebar and each becomes a layer in a default group that Icon Composer creates. Alternatively, drag folders containing graphic files to the sidebar. Then the folders become groups and the files in the folders become layers in those groups. Icon Composer organizes the groups and layers alphabetically using the same names as the folders and files.

Alternatively, click the Add button (+) under the sidebar and choose New Image from the pop-up menu. In the dialog that appears, select one or more files (use Command-click to select multiple files) and click Open.

Later, if you want to change the graphic file associated with a layer, select the layer in the sidebar and choose Replace from the Image pop-up menu under Composition in the Style inspector. Then, from the dialog that appears, select the new graphic file.

## Organize layers into groups

After you import the graphic files, organize the layers that appear in the default group into a maximum of four groups to reduce complexity. The groups become the layers in the app icon image the platform renders to give the icon its depth. The system renders the layers in the z-plane from the bottom to the top as they appear in the sidebar. Groups also allow you to apply common settings to multiple layers.

![A screenshot of the sidebar with callouts that show the groups and layers in the Landmarks sample app icon.](images/com.apple.Xcode/icon-composer-layer-groups@2x.png)

You can use the sidebar to make the following edits:

- To create a group, click the Add button at the bottom of the sidebar and choose New Group from the pop-up menu.
- To change the name of a group or layer, double-click it and enter a name.
- To move layers into groups, drag them to the groups you want them to be in.
- To change the order of a group or layer, drag them up or down. Alternatively, select a layer or group and choose Arrange > Bring [Group | Layer] Forward or Arrange > Send [Group | Layer] Backward (or similar) menu item.
- To add another layer, click the Add button and choose Image.

For more edits, Control-click a layer or group and choose an action from the contextual menu.

To collapse groups in the outline, click the disclosure triangle to the left of the group. To hide or show layers and groups in the canvas, click the eye icon to the right of the group or layer in the sidebar when you hold the pointer over it. Alternatively, hide or show layers and groups using the Visible toggle under Composition in the Style inspector.

To delete groups, layers, or graphics in a layer, select them in the sidebar or canvas, and press Delete. To revert your changes, choose Edit > Undo Delete.

## Customize the Icon Composer interface

Before you begin previewing variants and adding effects to your app icon, consider customizing the Icon Composer interface to show only the platforms that your app supports. Click the Document button in the upper-right corner and choose the platforms from the Document inspector.

![A screenshot of the Document inspector that shows the platform controls where you can select the platforms you support to reduce the complexity of the interface.](images/com.apple.Xcode/icon-composer-document-target-platforms@2x.png)

For example, if your app runs in iOS only, choose iOS Only from the iOS, macOS pop-up menu and toggle watchOS to off. Icon Composer hides the macOS and watchOS controls so that you can focus on the iOS app icon design.

## Preview variants of your app icon

Icon Composer shows you a preview of your app icon on different platforms (iOS, macOS, and watchOS) and, for iOS and macOS, different appearances (default, dark, and mono). For mono, you can preview clear and tinted variants as well. For watchOS, there are no appearances to preview.

Below the image of your icon in the canvas area, click a platform on the left and appearance on the right to preview or edit that variant. For example, to preview the dark appearance in iOS, select iOS on the left and Dark on the right.



![A screenshot that shows the Landmarks icon preview when you select the default appearance.](images/com.apple.Xcode/icon-composer-mode-preview-default@2x.png)



![A screenshot that shows the Landmarks icon preview when you select the dark appearance.](images/com.apple.Xcode/icon-composer-mode-preview-dark~dark@2x.png)



![A screenshot that shows the Landmarks icon preview when you select the mono appearance.](images/com.apple.Xcode/icon-composer-mode-preview-mono@2x.png)

To preview clear and tinted variants, click Mono and then click Options. From the dialog, select Light or Dark, toggle Tinted on or off, and select a tint color using the sliders.

![A screenshot that shows the Mono options settings with a toggle between light and dark appearance, a toggle for tinted, and color sliders.](images/com.apple.Xcode/icon-composer-mono-preview-settings@2x.png)

## Simulate device backgrounds, effects, and lighting

To preview your app icon in a different context, use the controls in the toolbar above the canvas area. These controls only change the simulated device where your app icon appears; they don’t edit your app icon.

![A screenshot with callouts that shows the effects, background, grid, and icon size controls.](images/com.apple.Xcode/icon-composer-canvas-preview-settings@2x.png)

You can use the toolbar controls to set the following:

- To change the background color, choose a color from the color well on the left.
- To change the background image, choose a background image from the Background Image pop-up menu. To use your own image, click Add Background in the pop-up menu.
- To switch between the background color and image, click the background toggle.
- To add grid lines, choose Light or Dark from the Grid pop-up menu.
- To toggle the grid lines on or off, click the Grid button.
- To view a specific size of the app icon, choose the size from the “Select preview size” pop-up menu.
- To zoom in or out, choose a percentage from the “Change zoom level” pop-up menu.
- To compare the app icon rendering on a previous with the current design generation, click the Effects buttons. For example, to compare macOS 26 with macOS 27 rendering, click 26 and then 27.
- To view the app icon with no Liquid Glass effects, toggle Effects off.



![A screenshot of the Effects controls with a callout for the toggle in the toolbar.](images/com.apple.Xcode/icon-composer-effects-toggle~dark@2x.png)



![A screenshot that shows an app icon preview in the canvas with the Liquid Glass effects turned on.](images/com.apple.Xcode/icon-composer-effects-on@2x.png)



![A screenshot that shows an app icon preview in the canvas with the Liquid Glass effects turned off.](images/com.apple.Xcode/icon-composer-effects-off@2x.png)

You can use these controls to see the transparency in the clear and tinted modes using your own backgrounds. For example, to preview the clear dark variant over a sample image, select iOS or macOS as the platform and Mono as the appearance. From the Mono options dialog, toggle Tinted off. Then choose Add Background from the Background Image pop-up menu at the top of the canvas and select the screenshot in the dialog that appears.

![A screenshot of the canvas that shows the mono appearance over a blue background image.](images/com.apple.Xcode/icon-composer-background-preview-mode-clear-dark@2x.png)

## Apply effects to the background, groups, and layers

As you preview the variants of your app icon on different platforms and device settings, apply effects and fix any problems you see using the Style inspector. Explore the different settings for groups and layers within a group.

In general, settings under Color are useful for creating variants for dark and mono appearances. For groups and layers, you customize the dynamic material under Liquid Glass. Then use the controls under Composition for varying your design on different platforms.

![A screenshot of the Style inspector with callouts that show the Color, Liquid Glass, and Composition areas of the settings.](images/com.apple.Xcode/icon-composer-applying-effects-inspector@2x.png)

To quickly duplicate settings, you can Control-click an individual setting or a section, and choose Copy [Setting | Section] or Paste [Setting | Section] from the contextual menu. Alternatively, Control-click a layer or group in the sidebar and choose Copy Style or Paste Style from the contextual menu (Edit > Copy Style and Edit > Paste Style).

For any text fields where you enter numbers, you can enter an equation and Xcode calculates the value for you. For example, enter `35*3`, or enter `*2` to double an existing value.

To remove any changes you make in the Style inspector, choose Edit > Undo.

## Apply a gradient fill and opacity

Under Color in the Style inspector, you can change a layer’s fill from the default value (Automatic) that Icon Composer gets from the graphic file. Select the layer in the sidebar, and from the Fill pop-up menu in the Style inspector, choose None, Solid, or Gradient.

![A screenshot of the Color settings for a layer that shows Fill set to Gradient with yellow as the “From” color and orange as the “To” color.](images/com.apple.Xcode/icon-composer-color-app-icon-layer@2x.png)

> Tip: To set an RGB value or hexadecimal (hex) color number for a color, use the RGB sliders in the Color Sliders inspector in the Color picker.

For example, apply a gradient to your app icon’s background following these steps:

1. In the sidebar, click the icon filename.
2. In the canvas, select a platform and, optionally, an appearance.
3. To show the settings, click the Style inspector in the upper-right corner of the window.
4. From the Color pop-up menu, choose All to change all variants.
5. From the Fill pop-up menu, choose Gradient.
6. From the two color wells that appear below, select the “From” and “To” colors.

To switch the colors, click the arrows to the left of the Gradient color wells when you hold the pointer over them. For layers, you can use the dots in the canvas that appear on the layer to change the “From” and “To” locations of the gradient.

![A screenshot that shows a layer selected in the sidebar on the left, the gradient dots on a shape in the canvas in the middle, and a from and to color set under Gradient on the right.](images/com.apple.Xcode/icon-composer-gradient-dots@2x.png)

To set the opacity of the “From” and “To” colors, change the percentage value on the right of the color wells. You can also use the Opacity setting under Color to make a group or layer transparent, revealing details behind it.

## Apply Liquid Glass effects to groups and layers

Icon Composer automatically adds the Liquid Glass material to layers when you import graphics files, and it applies other default Liquid Glass settings to groups when you create them.

![A screenshot that shows the Liquid Glass section of the Style inspector.](images/com.apple.Xcode/icon-composer-liquid-glass-settings@2x.png)

For a group, you have all the options to customize the Liquid Glass material. Select a group in the sidebar and choose Individual or Combined from the Mode pop-up menu in the inspector.

- To apply the effects to every layer in the group separately, choose Individual.
- To apply the effects to the layers in the group as one object, choose Combined.



![An illustration that represents layers in a group with Liquid Glass effects applied separately to each layer.](images/com.apple.Xcode/icon-composer-specular-highlight-individual@2x.png)



![An illustration that represents layers in a group with Liquid Glass effects applied to the group as one object.](images/com.apple.Xcode/icon-composer-specular-highlight-combined@2x.png)

Choose how specular highlights align with each layer, either inside or outside, or let the system decide. From the Specular pop-up menu, choose one of these options:

- To remove the specular highlights, choose Off.
- To apply the specular highlights and let the system determine whether it’s on the inside or outside of the artwork, choose Automatic.
- To apply the specular highlights on the inside of the artwork, choose Inside.
- To apply the specular highlights on the outside of the artwork, choose Outside.

Icon Composer sets the specular highlights to Automatic by default.

Below Specular, you can apply the rest of the Liquid Glass settings (Blur, Refraction, Translucency, and Shadow) to the group.

Refraction lets layers pick up and transmit color and shape from what’s behind them. To turn on refraction, toggle Refraction on. To change the strength of refraction, drag the circle around in the 2D space below or enter percentages in the text fields on the right.

To turn Liquid Glass off for an individual layer, select the layer in the sidebar, and in the inspector, turn off the Effects toggle under Liquid Glass.

> Note: In iOS, iPadOS, macOS, and watchOS versions earlier than 27, specular highlights appear on when you choose Inside or Outside, and Refraction settings have no visible effect.

## Change the position and scale of graphics

You can reposition and scale graphics in your layers using Icon Composer. Just select and drag the graphics in a layer or group that you want to move within the canvas area.

**Layer:**

![A screenshot of the sidebar on the left and the canvas on the right showing a layer selected.](images/com.apple.Xcode/icon-composer-layer-position-scale-layer@2x.png)

**Group:**

![A screenshot of the sidebar on the left and canvas on the right with a group selected.](images/com.apple.Xcode/icon-composer-layer-position-scale-group~dark@2x.png)

To move multiple groups, layers, or individual graphics, Command-click them in the sidebar or canvas first, or select them by dragging a bounding box in the canvas. Icon Composer highlights the selection in both the sidebar and canvas. To unselect all graphics, press the Escape key.

![A screenshot that shows layers in a group selected in both the sidebar and canvas before a move.](images/com.apple.Xcode/icon-composer-layer-group-drag@2x.png)

Use the guidelines that appear while dragging to align the selection with other graphics. To make more precise edits, you can enter an x, y, and scale in the Layout section of the Style inspector under Composition. To make single point changes, use the Up Arrow and Down Arrow keys.

![A screenshot that shows the Layout section under Composition with the x, y, and scale settings. ](images/com.apple.Xcode/icon-composer-composition-edit-selection@2x.png)

Optionally, turn the grid on so you can see where to place your graphics. In the toolbar, click the Grid button or choose Light or Dark from the Grid pop-up menu. Icon Composer overlays grid lines on the preview of your app icon in the color that you choose. To remove the grid lines, toggle Grid off.

![A screenshot that shows the Grid pop-up menu at the top of the canvas.](images/com.apple.Xcode/icon-composer-grid-toggle@2x.png)

For other ways to reposition the selection, use the Arrange > Align and Arrange > Distribute menu items.

## Customize variants of your app icon

You can customize specific platform and appearance variants of your app icon using the Style inspector.

To see settings that you customize, select the icon, a group, or a layer in the sidebar and choose All from the Color, Liquid Glass, or Composition pop-up menu in the Style inspector. The custom settings appear below the main setting. For example, if you change the Blend Mode setting for the dark and mono appearances in iOS, then a Dark and Mono setting appears below the Blend Mode setting. The main setting applies to the variants that you don’t customize.

![A screenshot that shows custom settings for dark and mono appearances when you choose All from the Color pop-up menu.](images/com.apple.Xcode/icon-composer-inspector-color-varied-by-mode@2x.png)

The Style inspector enables the controls for the platform or appearance that you select in the canvas. For example, to enable the Dark setting that appears below Blend Mode, select the dark appearance in the canvas.

To add another custom setting, select the platform or appearance in the canvas that you want to vary and in the Style inspector, click the icon next to the setting. Choose Vary for [appearance | platform] from the Add button pop-up menu. For example, select iOS / macOS and Default in the canvas and choose Vary for iOS / macOS from the Blur pop-up menu under Liquid Glass.

![A screenshot that shows the Vary for pop-up menu under the Refraction setting when you choose All from the Liquid Glass pop-up menu.](images/com.apple.Xcode/icon-composer-edit-all-exception@2x.png)

To remove custom settings, click the X next to the platform or appearance. For example, to remove the Dark setting under the Blend Mode setting, click the X next to Dark.

Alternatively, choose the appearance that you select in the canvas from the Color or Liquid Glass pop-up menu. Then the controls in that section only apply to that appearance. Similarly, choose the platform that you select in the canvas from the Composition pop-up menu and the controls in that section apply only to that platform. The controls behave in this way so that the appearance of your app icon remains consistent and only the geometry varies across platforms.

![A screenshot that shows Dark selected from the Color pop-up menu when you select the dark appearance in the canvas.](images/com.apple.Xcode/icon-composer-color-edit-selection@2x.png)

Then you can switch back to seeing all the custom settings you made for platforms and appearances in one place by choosing All from the Color, Liquid Glass, and Composition pop-up menus.

## Add your Icon Composer file to an Xcode project

If you create your Icon Composer file outside of Xcode, you can add it to your Xcode project anytime to view your icon in simulated and physical devices using [Device Hub](/documentation/Xcode/device-hub).

Just drag the Icon Composer file from Finder to the Project navigator, and Xcode provides feedback on where to drop it in a target folder. Alternatively, choose Add Files from the Add button at the bottom of the Project navigator and select your Icon Composer file in the dialog that appears.

In the project editor, select the target and the General tab. Under App Icons and Launch Screen, ensure that the name in the App Icon text field matches the name of the Icon Composer file without the extension. You can have multiple Icon Composer files in your project but only one that matches the name in the App Icon text field.

> Note: The latest version of Xcode uses the Icon Composer file instead of an existing `AppIcon` asset catalog in your project.

---

Copyright &copy; 2026 Apple Inc. All rights reserved. | [Terms of Use](https://www.apple.com/legal/internet-services/terms/site.html) | [Privacy Policy](https://www.apple.com/privacy/privacy-policy)

<!--
{
  "documentType" : "article",
  "framework" : "Xcode",
  "identifier" : "/documentation/Xcode/configuring-your-app-icon",
  "metadataVersion" : "0.1.0",
  "role" : "article",
  "title" : "Configuring your app icon using an asset catalog"
}
-->

# Configuring your app icon using an asset catalog
<!-- https://developer.apple.com/tutorials/data/documentation/xcode/configuring-your-app-icon.md -->
Add app icon variations to an asset catalog that represents your app in places such as the App Store, the Home Screen, Settings, and search results.

## Overview

> Important: To create your app icon using Icon Composer for all variants, including different platforms and appearances, see <doc://com.apple.Xcode/documentation/Xcode/creating-your-app-icon-using-icon-composer>.

Every app has a distinct app icon that communicates the app’s purpose and makes
it easy to recognize throughout the system. Apps require multiple variations
of the app icon to look great in different contexts. Xcode can help generate these
variations for you using a single high-resolution image, or you can configure your
app icon variations by using an app icon’s image set in your project’s asset catalog.
visionOS and tvOS app icons are made up of multiple stacked image layers you configure in
your project’s asset catalog. iOS and iPadOS app icons support additional dark and tinted styles.

For design guidance on app icons, see [Human Interface Guidelines > App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons).

### Create an app icon

When you create your project from a template, it automatically includes a default asset
catalog (`Assets.xcassets`) that contains the `AppIcon`. If you don’t have a default
asset catalog or existing `AppIcon` or you want to provide an alternate, you can
add an app icon to an asset catalog manually:

1. In the Project navigator, select an asset catalog.
2. Click the Add button (+) at the bottom of the outline view.
3. In the pop-up menu, choose *OS variant* > *OS variant* App Icon. Xcode creates
   a new app icon set or image stack with the name `AppIcon`.

### Specify app icon variations

Variations of your app icon appear throughout the system in places like the Home
View, Settings, and search results:

- iOS, iPadOS, tvOS, and watchOS apps can auto-generate all icon variations from a single 1024×1024 pixel image. This is the default behavior when you create a new iOS, iPadOS, tvOS, and watchOS app, or a new icon in the asset catalog. If you have an existing project that provides multiple variants,
  consider providing a single size when that is all your icon requires. However, if you want to customize your app’s icon variants, such as to show more detail at a larger size, you can provide individual assets for the variations.
- For macOS and tvOS, you need to supply an asset for each size.
- For visionOS, you need to supply a single 1024x1024 pixel asset.

For each platform your app supports, choose between using a single size and providing all sizes in the Asset Catalog:

![Screenshot of an asset catalog in Xcode. In the outline view, an app icon set with the name AppIcon is selected. The inspector area shows multiple image wells with labels that describe the required image dimensions, resolutions, and usages.](images/com.apple.Xcode/configuring-your-app-icon-1@2x.png)

1. In the Project navigator, select an asset catalog.
2. In the Asset Catalog, select the icon.
3. To view and edit attributes, select Inspectors > Attributes from Xcode’s View menu.
4. Select Single Size or All Sizes from the pop-up menu for the platform you want to change.

For each platform your app supports, add a single image that Xcode can use to generate your icon variations, or add an image for each icon variation of an icon set in the Asset Catalog:

![Screenshot of an asset catalog in Xcode. In the outline view, an app icon set with the name AppIcon is selected. The detail area shows multiple image wells with labels that describe the required image dimensions, resolutions, and usages.](images/com.apple.Xcode/configuring-your-app-icon-2@2x.png)

1. In the Project navigator, select an asset catalog.
2. In the Asset Catalog, select the icon.
3. From the Finder, drag image variations of the app icon to the image wells in the detail area of the Asset Catalog in Xcode that match their resolutions and use cases.
   visionOS and tvOS app icons combine a stack of multiple image layers to create a sense of depth. For tvOS apps, the asset catalog contains an App Icon & Top Shelf Image folder with the different app icon and launch image sets.

### Add dark and tinted icon variants to iOS and iPadOS

iOS and iPadOS support three stylistic variations for app icons: Light, Dark, and Tinted. You can create your own variations to ensure that each one looks exactly the way you way you want.

![Screenshot of an asset catalog in Xcode. In the outline view, an app icon set with the name AppIcon is selected. The inspector area shows multiple image wells with labels that describe the Any, Dark, and Tinted icon appearances.](images/com.apple.Xcode/configuring-your-app-icon-5@2x.png)

To add these icon variations to your app:

1. In the Project navigator, select an asset catalog.
2. In the Asset Catalog, select the icon.
3. Select View > Inspectors > Attributes from the Xcode menu.
4. Select Single Size from the iOS pop-up menu.
5. Then select Any, Dark, or Tinted from the Appearance pop-up menu.

After you select the Appearance from the pop-up menu, two image wells appear. Drag your dark and tinted app icons into the appropriate image well. Provide your tinted app icon as a grayscale image. Provide your dark app icon with a transparent background so the system-provided background can show through.

If you prefer, you can take advantage of the system’s automatically generated treatment that is applied to all app icons. It is crafted intelligently to preserve design intent and maintain legibility. This also helps maintain a consistent visual experience across the Home Screen.

For design guidance specific to iOS and iPadOS, see [Human Interface Guidelines > App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons).

### Configure the layers of an image stack

By default, visionOS and tvOS app icons are constructed with three layers. This is the maximum number of layers visionOS icons support but you can use up to five layers when constructing tvOS icons. To add a layer, Click the Add button, choose *OS variant* > *OS variant* App Icon Layer. To remove a layer, select the layer and click the Remove button (-).

![Screenshot of an asset catalog in Xcode. In the outline view, an app icon stack with the name AppIcon is selected. The detail area shows image wells for each layer of the stack with labels.](images/com.apple.Xcode/configuring-your-app-icon-3@2x.png)

Add images to each layer by dragging them from the Finder into the image wells in the detail area of the Asset Catalog in Xcode. For information on the use of layers, see App icons [visionOS](doc://com.apple.documentation/design/Human-Interface-Guidelines/app-icons) and [tvOS](doc://com.apple.documentation/design/Human-Interface-Guidelines/app-icons).

> Note: You can use Parallax Previewer app or Parallax Exporter plug-in to create and preview Layer Source Representation (.lsr and .xlsr) files that you can import into your Asset Catalog in Xcode. Save your file in the LSR file format to import a tvOS icon into Xcode, and save in the XLSR file format to import a visionOS icon. Download these from the [Apple Design Resources](https://developer.apple.com/design/resources) site.

### Specify an App Store icon

If you distribute your app through the App Store, you must provide app icon imagery to use in the App Store. In the Project navigator, select an asset catalog and add icon images to the appropriate image wells in an app icon set or image stack. The App Store image well location varies by platform.

|Platform    |App Store icon location                                                                                                                                                                                        |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|iOS         |Drag an icon image to the iOS 1,024pt image well.                                                                                                                                                              |
|iMessage    |For the iOS target, drag an icon image to the iOS 1,024pt image well in the `AppIcon` set. For the iMessage Extension target, drag an icon to the Messages App Store image well in the `iMessage App Icon` set.|
|Sticker Pack|Drag an icon image to the iOS 1,024pt image well and the Messages App Store image well.                                                                                                                        |
|macOS       |Drag an icon image to the App Store - 2x image well.                                                                                                                                                           |
|tvOS        |Drag images to the image wells for the layers of your App Icon - App Store stack in the App Icon & Top Shelf Image folder. The App Store generates an icon from the layers of the image stack.                 |
|visionOS    |Drag images to the image wells for the layers of your visionOS App Icon stack. The App Store generates an icon from the layers of the image stack.                                                             |
|watchOS     |For the iOS target, drag an icon image to the iOS 1,024pt image well. For the WatchKit App target, drag an icon image to the watchOS image well.                                                               |

### Change the default app icon set

If you don’t create your project from a template, or you want to change your
default app icon set, specify which one to use in your target’s build settings.

1. In the Project navigator, select the project and in the project editor, select
   the target.
2. In the App Icons and Launch Screen section of the General pane, choose the
   app icon set from the App Icons Source pop-up menu.

![Screenshot of target settings with the General tab selected. The App Icons and Launch Screen section shows a field with the name App Icons Source that lists the name of the app icon set to use from the asset catalog.](images/com.apple.Xcode/configuring-your-app-icon-4@2x.png)

If you don’t select the Include all app icon assets option, Xcode only includes
the app icon set you specify in the App Icons Source pop-up menu when it builds your app.
You might leave this option unselected if you want to use a different icon for
the Debug and Release builds of your app without including the Debug icon in your
Release app bundle.
You can specialize the app icon for the Debug and Release configurations by modifying
the Primary App Icon Set Name build setting in the Build Settings tab.

Xcode also includes any additional app icon sets you specify under the Alternate App Icon Sets
build setting. Include any icon sets your app can select using <doc://com.apple.documentation/documentation/UIKit/UIApplication/setAlternateIconName(_:completionHandler:)>
or use in App Store product pages.

For information on configuring tests that use icons in App Store Connect, see [Product Page Optimization](https://developer.apple.com/app-store/product-page-optimization).

---

Copyright &copy; 2026 Apple Inc. All rights reserved. | [Terms of Use](https://www.apple.com/legal/internet-services/terms/site.html) | [Privacy Policy](https://www.apple.com/privacy/privacy-policy)

---

# App icons
<!-- https://developer.apple.com/design/human-interface-guidelines/app-icons -->
A unique, memorable icon expresses your app’s or game’s purpose and personality and helps people recognize it at a glance.

## Discussion

![A sketch of the App Store icon. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](images/com.apple.HIG/foundations-app-icons-intro~dark@2x.png)

Your app icon is a crucial aspect of your app’s or game’s branding and user experience. It appears on the Home Screen and in key locations throughout the system, including search results, notifications, system settings, and share sheets. A well-designed app icon conveys your app’s or game’s identity clearly and consistently across all Apple platforms.

![An image that shows three variations of the Photos app's app icon as it appears on different platforms. The first variation is a rounded rectangle shape, and represents the iOS, iPadOS, and macOS icons. The second variation is an elongated, rounded rectangular shape, and represents the tvOS icon. The third variation is a circular shape, and represents the visionOS and watchOS icons. All variations have the same overall design over different background shapes.](images/com.apple.HIG/app-icons-platform-appearance-overview@2x.png)

## Layer design

Although you can provide a flattened image for your icon, layers give you the most control over how your icon design is represented. A layered app icon comes together to produce a sense of depth and vitality. On each platform, the system applies visual effects that respond to the environment and people’s interactions.

iOS, iPadOS, macOS, and watchOS app icons include a background layer and one or more foreground layers that coalesce to create dimensionality. These icons take on Liquid Glass attributes like specular highlights, refraction, and translucency. These effects automatically adapt with the size of your icon, apply consistently across platforms, and can appear differently between system versions.

tvOS app icons use between two and five layers to create a sense of dynamism as people bring them into focus. When focused, the app icon elevates to the foreground in response to someone’s finger movement on their remote, and gently sways while the surface illuminates. The separation between layers and the use of transparency produce a feeling of depth during the parallax effect.

A visionOS app icon includes a background layer and one or two layers on top, producing a three-dimensional object that subtly expands when people view it. The system enhances the icon’s visual dimensionality by adding shadows that convey a sense of depth between layers and by using the alpha channel of the upper layers to create an embossed appearance.

![An animation of the Photos app icon in visionOS moving to show the parallax effect.](videos/com.apple.HIG/visionos-app-icon-showcase.mp4)

    visionOS app icon

You use your favorite design tool to craft the individual foreground layers of your app icon. For iOS, iPadOS, macOS, and watchOS icons, you then import your icon layers into Icon Composer, a design tool included with Xcode and available from the [Apple Developer website](https://developer.apple.com/icon-composer). In Icon Composer, you define the background layer for your icon, adjust your foreground layer placement, apply visual effects like specular highlights and refraction, annotate for default, dark, and mono appearance variants, test and preview your icon across system versions, and export your icon for use in Xcode. For additional guidance, see [Creating your app icon using Icon Composer](/documentation/Xcode/creating-your-app-icon-using-icon-composer).

![A screenshot of the Photos app icon in Icon Composer.](images/com.apple.HIG/app-icons-icon-composer-overview-photos~dark@2x.png)

For tvOS and visionOS app icons, you add your icon layers directly to an image stack in Xcode to form your complete icon. You can download Parallax Previewer and Parallax Exporter plug-in from [Apple Design Resources](https://developer.apple.com/design/resources/) to preview and test parallax visual effects. For developer guidance, see [Configuring your app icon using an asset catalog](/documentation/Xcode/configuring-your-app-icon).

**Prefer clearly defined edges in foreground layers.** To ensure system-drawn highlights and shadows look best, avoid soft and feathered edges on foreground layer shapes.

**Vary opacity in foreground layers to increase the sense of depth and liveliness.** For example, the Photos icon separates its centerpiece into multiple layers that contain translucent pieces, bringing greater dynamism to the design. Importing fully opaque layers and adjusting transparency in Icon Composer lets you preview and make adjustments to your design based on how transparency and system effects impact one another.

**Design a background that both stands out and emphasizes foreground content.** If you choose a gradient for your background layer, ensure that it responds well to system lighting effects. Icon Composer supports solid colors and gradients for background layers, making it unnecessary to import custom background images in most cases. If you do import a background layer, make sure it’s full-bleed and opaque.

**Prefer vector graphics when bringing layers into Icon Composer.** Unlike raster images, vector graphics (such as SVG or PDF) scale gracefully and appear crisp at any size. Outline artwork and convert text to outline in your design. For mesh gradients and raster artwork, prefer PNG format because it’s a lossless image format.

## Icon shape

An app icon’s shape varies based on a platform’s visual language. In iOS, iPadOS, and macOS, icons are square, and the system applies masking to produce rounded corners that precisely match the curvature of other rounded interface elements throughout the system and the bezel of the physical device itself. In tvOS, icons are rectangular, also with concentric edges. In visionOS and watchOS, icons are square and the system applies circular masking.

**iOS, iPadOS, macOS:**

![An image of the Settings icon for iOS. The iOS, iPadOS, and macOS icon grid is overlaid on the icon to show how the icon's shape and its elements map to the grid.](images/com.apple.HIG/app-icons-settings-app-grid-square~dark@2x.png)

**tvOS:**

![An image of the Settings icon for tvOS. The tvOS icon grid is overlaid on the icon to show how the icon's shape and its elements map to the grid.](images/com.apple.HIG/app-icons-settings-app-grid-rectangle@2x.png)

**visionOS, watchOS:**

![An image of the Settings icon for watchOS. The visionOS and watchOS icon grid is overlaid on the icon to show how the icon's shape and its elements map to the grid.](images/com.apple.HIG/app-icons-settings-app-grid-circle~dark@2x.png)

**Produce appropriately shaped, unmasked layers.** The system masks all layer edges to produce an icon’s final shape. For iOS, iPadOS, and macOS icons, provide square layers so the system can apply rounded corners. For visionOS and watchOS, provide square layers so the system can create the circular icon shape. For tvOS, provide rectangular layers so the system can apply rounded corners. Providing layers with pre-defined masking negatively impacts specular highlight effects and makes edges look jagged.

**Keep primary content centered to avoid truncation when the system adjusts corners or applies masking.** Pay particular attention to centering content in visionOS and watchOS icons. To help with icon placement, use the grids in the app icon production templates, which you can find in [Apple Design Resources](https://developer.apple.com/design/resources/).

## Design

Embrace simplicity in your icon design. Simple icons tend to be easiest for people to understand and recognize. An icon with fine visual features might look busy when rendered with system-provided shadows and highlights, and details may be hard to discern at smaller sizes. Find a concept or element that captures the essence of your app or game, make it the core idea of your icon, and express it in a simple, unique way with a minimal number of shapes. Prefer a simple background, such as a solid color or gradient, that puts the emphasis on your primary design — you don’t need to fill the entire icon canvas with content.

![An image of the Podcasts app icon.](images/com.apple.HIG/app-icons-embrace-simplicity-podcasts@2x.png)

![An image of the Home app icon.](images/com.apple.HIG/app-icons-embrace-simplicity-home@2x.png)

**Provide a visually consistent icon design across all the platforms your app supports.** A consistent design helps people quickly find your app wherever it appears and prevents people from mistaking your app for multiple apps.

**Consider basing your icon design around filled, overlapping shapes.** Overlapping solid shapes in the foreground, particularly when paired with transparency and blurring, can give an icon a sense of depth.

![An illustration of two circles centered above a grid. One circle encloses the other. The inner circle has a solid fill. The outer circle is larger than the inner circle, allowing some space between them. The outer circle has no fill and shows just an outline.](images/com.apple.HIG/app-icons-element-outline-shape@2x.png)

![An X in a circle to indicate incorrect usage.](images/com.apple.HIG/crossout@2x.png)

![An illustration of two circles centered above a grid. One circle encloses the other. The inner circle has a solid fill. The outer circle is larger than the inner circle, has no outline, and has a semi-transparent fill that allows the background grid to show through. Together, the two circles give the impression that the inner circle is resting upon the outer circle.](images/com.apple.HIG/app-icons-element-filled-shape@2x.png)

![A checkmark in a circle to indicate correct usage.](images/com.apple.HIG/checkmark@2x.png)

**Include text only when it’s essential to your experience or brand.** Text in icons doesn’t support accessibility or localization, is often too small to read easily, and can make an icon appear cluttered. In some contexts, your app name already appears nearby, making it redundant to display the name within the icon itself. Although displaying a mnemonic like the first letter of your app’s name can help people recognize your app or game, avoid including nonessential words that tell people what to do with it — like “Watch” or “Play” — or context-specific terms like “New” or “For visionOS.” If you include text in a tvOS app icon, make sure it’s above other layers so it’s not cropped by the parallax effect.

**Prefer illustrations to photos and avoid replicating UI components.** Photos are full of details that don’t work well when displayed in different appearances, viewed at small sizes, or split into layers. Instead of using photos, create a graphic representation of the content that emphasizes the features you want people to notice. Make sure to avoid extremely thin line weights and sharp corners, because they tend to lose detail and crispness in smaller icon sizes at lower resolutions. If your app has an interface that people recognize, don’t just replicate standard UI components or use app screenshots in your icon.

**Don’t use replicas of Apple hardware products.** Apple products are copyrighted and can’t be reproduced in your app icons.

## Visual effects

**Let the system handle blurring and other visual effects.** The system dynamically applies visual effects to your app icon layers, so there’s no need to include specular highlights, drop shadows between layers, beveled edges, blurs, glows, and other effects. In addition to interfering with system-provided effects, custom effects are static, whereas the system supplies dynamic ones. If you do include custom visual effects on your icon layers, use them intentionally and test carefully with Icon Composer, on a simulated device in Device Hub, or on a physical device to make sure they appear as expected and don’t conflict with system effects.

**Create layer groupings to apply effects to multiple layers at once.** System effects typically occur on individual layers. If it makes sense for your design, however, you can group several layers together in Icon Composer or your design tool so effects occur at the group level. For a group, Icon Composer provides additional customization options for Liquid Glass effects, so you can configure attributes like specular highlights, refraction, and translucency.

## Appearances

In iOS, iPadOS, and macOS, people can choose whether their Home Screen app icons are default, dark, clear, or tinted in appearance. For example, someone may want to personalize their app icon appearance to complement their wallpaper. You can design app icon variants for every appearance variant, and the system automatically generates variants you don’t provide.

![A grid showing the six different appearances of the Photos app icon in iOS. The top row shows the default, clear light, and tinted light icon variants. The bottom row shows the dark, clear dark, and tinted dark variants.](images/com.apple.HIG/app-icons-rendering-modes@2x.png)

**Keep your icon’s features consistent across appearances.** To create a seamless experience, keep your icon’s core visual features the same in the default, dark, clear, and tinted appearances. Avoid creating custom icon variants that swap elements in and out with each variant, which may make it harder for people to find your app when they switch appearances.

**Design dark and tinted icons that feel at home beside system app icons and widgets.** You can preserve the color palette of your default icon, but be mindful that dark icons are more subdued, and clear and tinted icons are even more so. A great app icon is visible, legible, and recognizable, regardless of its appearance variant.

**Use your light app icon as the basis for your dark icon.** Choose complementary colors that reflect the default design, and avoid excessively bright images. Color backgrounds generally offer the greatest contrast in dark icons. For guidance, see [Dark Mode](/design/Human-Interface-Guidelines/dark-mode).

**Consider offering alternate app icons.** In iOS, iPadOS, tvOS, and compatible apps running in visionOS, it’s possible to let people visit your app’s settings to choose an alternate version of your app icon. For example, a sports app might offer icons for different teams, letting someone choose their favorite. If you offer this capability, make sure each icon you design remains closely related to your content and experience. Avoid creating one someone might mistake for another app.

> Note: Alternate app icons in iOS and iPadOS require their own dark, clear, and tinted variants. As with your default app icon, all alternate and variant icons are subject to app review and must adhere to the [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/#design).

## Platform considerations

*No additional considerations for iOS, iPadOS, or macOS.*

### tvOS

**Include a safe zone to ensure the system doesn’t crop your content.** When someone focuses your app icon, the system may crop content around the edges as the icon scales and moves. To ensure that your icon’s content is always visible, keep a safe zone around it. Be aware that the safe zone can vary, depending on the image size, layer depth, and motion, and the system crops foreground layers more than background layers.

![A diagram of the Settings icon in tvOS with a white dotted line inside the outer border, which indicates the safe zone.](images/com.apple.HIG/tvos-app-icon-safe-zone~dark@2x.png)

### visionOS

**Avoid adding a shape that’s intended to look like a hole or concave area to the background layer.** The system-added shadow and specular highlights can make such a shape stand out instead of recede.

### watchOS

**Avoid using black for your icon’s background.** Lighten a black background so the icon doesn’t blend into the display background.

## Specifications

The layout, size, style, and appearances of app icons vary by platform.

|Platform          |Layout shape         |Icon shape after system masking|Layout size |Style             |Appearances                                                      |
|------------------|---------------------|-------------------------------|------------|------------------|-----------------------------------------------------------------|
|iOS, iPadOS, macOS|Square               |Rounded rectangle (square)     |1024x1024 px|Layered           |Default, dark, clear light, clear dark, tinted light, tinted dark|
|tvOS              |Rectangle (landscape)|Rounded rectangle (rectangular)|800x480 px  |Layered (Parallax)|N/A                                                              |
|visionOS          |Square               |Circular                       |1024x1024 px|Layered (3D)      |N/A                                                              |
|watchOS           |Square               |Circular                       |1088x1088 px|Layered           |N/A                                                              |

The system automatically scales your icon to produce smaller variants that appear in certain locations, such as Settings and notifications.

App icons support the following color spaces:

- sRGB (color)
- Gray Gamma 2.2 (grayscale)
- Display P3 (wide-gamut color in iOS, iPadOS, macOS, tvOS, and watchOS only)

## Resources

#### Related

[Apple Design Resources](https://developer.apple.com/design/resources/)

[Icon Composer](https://developer.apple.com/icon-composer/)

[Icons](/design/Human-Interface-Guidelines/icons)

[Images](/design/Human-Interface-Guidelines/images)

[Dark Mode](/design/Human-Interface-Guidelines/dark-mode)

#### Developer documentation

[Creating your app icon using Icon Composer](/documentation/Xcode/creating-your-app-icon-using-icon-composer)

[Configuring your app icon using an asset catalog](/documentation/Xcode/configuring-your-app-icon)

#### Videos

- [Say hello to the new look of app icons](https://developer.apple.com/videos/play/wwdc2025/220/)
- [Create icons with Icon Composer](https://developer.apple.com/videos/play/wwdc2025/361/)

## Change log

|Date              |Changes                                                                                                      |
|------------------|-------------------------------------------------------------------------------------------------------------|
|June 8, 2026      |Refined guidance for Liquid Glass.                                                                           |
|June 9, 2025      |Updated guidance to reflect layered icons, consistency across platforms, and best practices for Liquid Glass.|
|June 10, 2024     |Added guidance for creating dark and tinted app icon variants for iOS and iPadOS.                            |
|January 31, 2024  |Clarified platform availability for alternate app icons.                                                     |
|June 21, 2023     |Updated to include guidance for visionOS.                                                                    |
|September 14, 2022|Added specifications for Apple Watch Ultra.                                                                  |

---

Copyright &copy; 2026 Apple Inc. All rights reserved. | [Terms of Use](https://www.apple.com/legal/internet-services/terms/site.html) | [Privacy Policy](https://www.apple.com/privacy/privacy-policy)
