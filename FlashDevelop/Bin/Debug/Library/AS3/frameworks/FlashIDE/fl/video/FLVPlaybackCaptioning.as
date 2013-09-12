﻿package fl.video
{
	import flash.ui.Keyboard;
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.utils.*;

	/**
	 * Dispatched when a caption is added or removed from the caption target
	 */
	[Event("captionChange", type="fl.video.CaptionChangeEvent")] 
	/**
	 * Dispatched after the <code>captionTarget</code> property is created, 
	 */
	[Event("captionTargetCreated", type="fl.video.CaptionTargetEvent")] 
	/**
	 * Dispatched after all of the Timed Text XML data is loaded. 
	 */
	[Event("complete", type="flash.events.Event")] 
	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event attempts to access a Timed Text XML file
	 */
	[Event("httpStatus", type="flash.events.HTTPStatusEvent")] 
	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event results in a fatal error
	 */
	[Event("ioError", type="flash.events.IOErrorEvent")] 
	/**
	 * Dispatched when the download operation to load the Timed Text XML file
	 */
	[Event("open", type="flash.events.Event")] 
	/**
	 * Dispatched when data is received as the download of the 
	 */
	[Event("progress", type="flash.events.ProgressEvent")] 
	/**
	 * Dispatched if a call to the <code>URLLoader.load()</code> event attempts to load a 
	 */
	[Event("securityError", type="flash.events.SecurityErrorEvent")] 

	/**
	 The FLVPlaybackCaptioning component enables captioning for the FLVPlayback component.
	 */
	public class FLVPlaybackCaptioning extends Sprite
	{
		/**
		 * @private
		 */
		local var ttm : TimedTextManager;
		/**
		 * @private
		 */
		local var visibleCaptions : Array;
		/**
		 * @private
		 */
		local var hasSeeked : Boolean;
		/**
		 * @private
		 */
		local var flvPos : Rectangle;
		/**
		 * @private
		 */
		local var prevCaptionTargetHeight : Number;
		/**
		 * @private
		 */
		local var captionTargetOwned : Boolean;
		/**
		 * @private
		 */
		local var captionTargetLastHeight : Number;
		/**
		 * @private
		 */
		local var captionToggleButton : Sprite;
		/**
		 * @private
		 */
		local var onButton : Sprite;
		/**
		 * @private
		 */
		local var offButton : Sprite;
		/**
		 * @private
		 */
		local var captionToggleButtonWaiting : Sprite;
		/**
		 * @private
		 */
		static const AUTO_VALUE : String = "auto";
		/**
		 * @private
		 */
		local var _captionTarget : TextField;
		/**
		 * @private
		 */
		local var _captionTargetContainer : DisplayObjectContainer;
		/**
		 * @private
		 */
		local var cacheCaptionTargetParent : DisplayObjectContainer;
		/**
		 * @private
		 */
		local var cacheCaptionTargetIndex : int;
		/**
		 * @private
		 */
		local var cacheCaptionTargetAutoLayout : Boolean;
		/**
		 * @private
		 */
		local var cacheCaptionTargetLocation : Rectangle;
		/**
		 * @private
		 */
		local var cacheCaptionTargetScaleY : Number;
		/**
		 * Used when keeing flvplayback skin above the caption
		 */
		local var skinHijacked : Boolean;
		private var _autoLayout : Boolean;
		private var _captionsOn : Boolean;
		private var _captionURL : String;
		private var _flvPlaybackName : String;
		private var _flvPlayback : FLVPlayback;
		private var _captionTargetName : String;
		private var _videoPlayerIndex : uint;
		private var _limitFormatting : Boolean;
		private var _track : uint;
		private var _captionsOnCache : Boolean;

		/**
		 * Used to display captions; <code>true</code> = display captions, 
		 */
		public function get showCaptions () : Boolean;
		/**
		 * @private
		 */
		public function set showCaptions (b:Boolean) : void;
		/**
		 * URL of the Timed Text XML file that contains caption information (<b>required property</b>).
		 */
		public function get source () : String;
		/**
		 * @private
		 */
		public function set source (url:String) : void;
		/**
		 * Determines whether the FLVPlaybackCaptioning component
		 */
		public function get autoLayout () : Boolean;
		/**
		 * @private
		 */
		public function set autoLayout (b:Boolean) : void;
		/**
		 * The instance name of the TextField object or MovieClip enclosing a Textfield object
		 */
		public function get captionTargetName () : String;
		/**
		 * @private
		 */
		public function set captionTargetName (tname:String) : void;
		/**
		 * Sets the DisplayObject instance in which to display captions. 
		 */
		public function get captionTarget () : DisplayObject;
		/**
		 * @private
		 */
		public function set captionTarget (ct:DisplayObject) : void;
		/**
		 * Defines the captionButton FLVPlayback custom UI component instance
		 */
		public function get captionButton () : Sprite;
		public function set captionButton (s:Sprite) : void;
		/**
		 * Sets an FLVPlayback instance name for the FLVPlayback instance
		 */
		public function get flvPlaybackName () : String;
		/**
		 * @private
		 */
		public function set flvPlaybackName (flvname:String) : void;
		/**
		 * Sets the FLVPlayback instance to caption.  The FLVPlayback
		 */
		public function get flvPlayback () : FLVPlayback;
		/**
		 * @private
		 */
		public function set flvPlayback (fp:FLVPlayback) : void;
		/**
		 * Support for multiple language tracks.  
		 */
		public function get track () : uint;
		/**
		 * @private
		 */
		public function set track (i:uint) : void;
		/**
		 * Connects the captioning to a specific VideoPlayer in the
		 */
		public function get videoPlayerIndex () : uint;
		/**
		 * @private
		 */
		public function set videoPlayerIndex (v:uint) : void;
		/**
		 * Limits formatting instructions 
		 */
		public function get simpleFormatting () : Boolean;
		/**
		 * @private
		 */
		public function set simpleFormatting (b:Boolean) : void;

		/**
		 * Creates a new FLVPlaybackCaptioning instance. 
		 */
		public function FLVPlaybackCaptioning ();
		/**
		 * @private
		 */
		function forwardEvent (e:Event) : void;
		/**
		 * @private
		 */
		function startLoad (e:Event) : void;
		/**
		 * @private
		 */
		function hookupCaptionToggle (e:Event) : void;
		/**
		 * @private
		 */
		function handleCaption (e:MetadataEvent) : void;
		/**
		 * @private
		 */
		function handleStateChange (e:VideoEvent) : void;
		/**
		 * @private
		 */
		function handleComplete (e:VideoEvent) : void;
		/**
		 * @private
		 */
		function handlePlayheadUpdate (e:VideoEvent) : void;
		/**
		 * @private
		 */
		function handleSkinLoad (e:VideoEvent) : void;
		/**
		 * @private
		 */
		function handleAddedToStage (e:Event) : void;
		/**
		 * @private
		 */
		function handleFullScreenEvent (e:FullScreenEvent) : void;
		/**
		 * @private
		 */
		function enterFullScreenTakeOver () : void;
		/**
		 * @private
		 */
		function exitFullScreenTakeOver () : void;
		/**
		 * @private
		 */
		function cleanupCaptionButton () : void;
		/**
		 * @private
		 */
		function setupButton (ctrl:Sprite, prefix:String, vis:Boolean) : Sprite;
		/**
		 * @private
		 */
		function handleButtonClick (e:MouseEvent) : void;
		/**
		 * This function stolen from UIManager and tweaked.
		 */
		function setupButtonSkin (prefix:String) : Sprite;
		/**
		 * @private
		 */
		function removeOldCaptions (playheadTime:Number, removedCaptionsIn:Array = null) : void;
		/**
		 * @private
		 */
		function findFLVPlayback () : void;
		/**
		 * @private
		 */
		function createCaptionTarget () : void;
		/**
		 * @private
		 */
		function layoutCaptionTarget (e:LayoutEvent = null) : void;
		/**
		 * @private
		 */
		function addFLVPlaybackListeners () : void;
		/**
		 * @private
		 */
		function removeFLVPlaybackListeners () : void;
		/**
		 * @private
		 */
		function getCaptionText (cp:Object) : String;
		/**
		 * @private
		 */
		function displayCaptionNow () : void;
		/**
		 * Keeps screen reader from reading captionTarget
		 */
		function silenceCaptionTarget () : void;
		/**
		 * Defines accessibility properties for caption toggle buttons
		 */
		function setupCaptionButtonAccessibility () : void;
		/**
		 * Handles keyboard events for accessibility
		 */
		function handleKeyEvent (e:KeyboardEvent) : void;
		/**
		 * Handles a mouse focus change event and forces focus on the appropriate control.
		 */
		private function handleMouseFocusChangeEvent (event:FocusEvent) : void;
		/**
		 * Returns a string containing all captions as an HTML-formatted transcript. 
		 */
		public function getCaptionsAsTranscript (preserveFormatting:Boolean = false) : String;
		/**
		 * Returns an array of FLVPlayback component cuepoints that contain the captions.
		 */
		public function getCaptionsAsArray () : Array;
		/**
		 * Returns a number of seconds as a timecode string.
		 */
		public function secondsToTime (sec:Number) : String;
		/**
		 * Returns an array of FLVPlayback component cuepoints whose caption text contains the search string.
		 */
		public function findInCaptions (searchString:String) : Array;
	}
}