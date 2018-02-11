// Search and Replace.
//
// Search and replace plain text content in user-selected set of groups.
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

// Prompt for search term
searchTermDialog = currentApp.displayDialog("Enter search term:", {withTitle: "Search", defaultAnswer:""});
searchTerm = searchTermDialog.textReturned;

// Prompt for replace term
replaceTerm = undefined;
if (searchTerm !== undefined) {
	replaceTermDialog = currentApp.displayDialog("Enter replacement:", {withTitle: "Replace", defaultAnswer:""});
	replaceTerm = replaceTermDialog.textReturned;
}

// Search and replace
if (replaceTerm !== undefined) {
	console.log(`Replace ${searchTerm} with ${replaceTerm}`);
	listResult.forEach(function(groupName) {
		const aGroup = TextExpander.groups.whose({name:{_equals:groupName}})[0];
		aGroup.snippets().forEach(function(aSnippet) {
			// Handle search and replace for plain text snippets
			if (aSnippet.contentType() === 'plain_text') {
				originalContent = aSnippet.plainTextExpansion();
				newContent = replaceAll(originalContent, searchTerm, replaceTerm);
				if (newContent && originalContent !== newContent) {
					console.log(`Replace\n${originalContent}\n…with…\n${newContent}`);					
					aSnippet.plainTextExpansion = newContent;
				}
			}
			if (aSnippet.contentType() === 'html_text') {
				console.log(`Snippet for abbreviation [${aSnippet.abbreviation()}] is rich text, so we aren't doing any replacing, as we need to do that by traversing the DOM.`);
			}			
		});
	});
}

// Utility functions
function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}
