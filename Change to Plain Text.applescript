// Change to Plain Text.
//
// Change all snippets in user-selected list of groups to plain text.
// Also, a good example of performing a specific behavior on a set of user-selected groups.
//
// Copyright 2018 SmileOnMyMac, LLC. See LICENSE.md for license terms.

// Preliminaries
TextExpander = Application('TextExpander');
Finder = Application('Finder');
currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;

// Get sorted list of group names
groupNames = TextExpander.groups.name().sort();

// Let user pick group(s) to process
listResult = currentApp.chooseFromList(groupNames, {withTitle:'Groups', withPrompt:'Please pick group(s) to search.', multipleSelectionsAllowed:true, emptySelectionAllowed:false});


listResult.forEach(function(groupName) {
	const aGroup = TextExpander.groups.whose({name:{_equals:groupName}})[0];
	aGroup.snippets().forEach(function(aSnippet) {
		if (aSnippet.contentType() !== 'plain_text') {
			aSnippet.contentType = 'plain_text';
		}
	});
});

currentApp.displayDialog('Change completed.', {buttons:['OK'], defaultButton:'OK'});
