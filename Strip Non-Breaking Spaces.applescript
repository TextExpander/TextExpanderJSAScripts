// Strip Non-Breaking Spaces.
//
// Strip non-breaking spaces from shell script snippets in user-selected group(s)
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

var count = 0;

listResult.forEach(function(groupName) {
	const aGroup = TextExpander.groups.whose({name:{_equals:groupName}})[0];
	
	aGroup.snippets().forEach(function(aSnippet) {
		if (aSnippet.contentType() === 'shell_script') {
			originalText = aSnippet.plainTextExpansion();
			aSnippet.plainTextExpansion = aSnippet.plainTextExpansion().replace(/\u00A0/g,' ');
			if (originalText !== aSnippet.plainTextExpansion()) {
				count++;
			}
		}
	});
});

// Result is count of updated snippets
count;
