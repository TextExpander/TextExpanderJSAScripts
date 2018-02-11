// Change Case Behavior.
//
// Allow user to select groups then to select desired case sensitivity behavior for those
// groups, then apply those changes.
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
listResult = currentApp.chooseFromList(groupNames, {withTitle:'Groups', withPrompt:'Please pick group(s) to change.', multipleSelectionsAllowed:true, emptySelectionAllowed:false});

// Let user pick behavior to apply to groups
caseChoice = currentApp.chooseFromList(['Case Sensitive (aB, Ab, ab, differ)', 'Ignore Case (aB, Ab, ab same)', 'Adapt to Case of Abbreviation'], {withTitle: 'Choose New Case Behavior', withPrompt:'Please choose the case behavior to apply to all of the previously selected groups, or click Cancel to exit without making any changes.'});
newAbbreviationMode = undefined;
switch(caseChoice[0]) {
	case 'Case Sensitive (aB, Ab, ab, differ)':
		newAbbreviationMode = 'case sensitive';
		break;
	case 'Ignore Case (aB, Ab, ab same)':
		newAbbreviationMode = 'ignore case';
		break;
	case 'Adapt to Case of Abbreviation':
		newAbbreviationMode = 'match case';
		break;
}

// If user picked, go ahead and apply the changes
if (newAbbreviationMode !== undefined) {
	listResult.forEach(function(groupName) {
		const aGroup = TextExpander.groups.whose({name:{_equals:groupName}})[0];
		aGroup.snippets().forEach(function(aSnippet) {
			if (aSnippet.abbreviationMode() != newAbbreviationMode) {
				aSnippet.abbreviationMode = newAbbreviationMode;
			}
		});
	});
	currentApp.displayDialog('Change completed.', {buttons:['OK'], defaultButton:'OK'});
} else {
	currentApp.displayDialog('No changes made.', {buttons:['OK'], defaultButton:'OK'});
}

