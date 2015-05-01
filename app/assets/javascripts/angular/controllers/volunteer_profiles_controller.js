var app = angular.module('timeauction.controllers', []);

app.controller('VolunteerProfilesCtrl', ['$scope', 'Roles', function($scope, Roles) {
  $("body").on("click", ".hours_entry-dates-holder-toggle", function() {
    toggleDateToggles($(this))
    toggleDatesHolder($(this))
  })

  $("body").on("click", ".hours-entry-date-toggle", function() {
    $(this).siblings(".hours-entry-details").toggle()
  })

  $("body").on("click", ".edit-role-title-text", function() {
    $(this).siblings(".edit-role-title-input-holder").toggle()
    $(this).parents(".top-section").siblings(".role-description").find(".role-description-input-holder").toggle()
    $(this).parents(".top-section").siblings(".role-description").find(".save-role-details-button").toggle()
  })

  $("body").on("click", ".edit-role-description-text", function() {
    toggleBackFromBottomSection($(this))
    $(this).siblings(".save-role-details-button").toggle()
  })

  $("body").on("click", ".save-role-details-button", function() {
    var url = $(this).attr("data-url")
    var roleId = $(this).attr("data-role-id")
    var title = $(this).parents(".role-description").siblings(".top-section").find(".edit-role-input").val()
    var description = $(this).siblings(".role-description-input-holder").find(".role-description-input").val()

    Roles.saveRoleDetails(url, roleId, title, description)
    displayEditedDetails($(this), title, description)
    toggleBackFromBottomSection($(this))
    $(this).toggle()
  })

  function toggleDateToggles(ele) {
    ele.toggle()
    ele.siblings(".plus-toggle").toggle()
    ele.siblings(".minus-toggle").toggle()
  }

  function toggleDatesHolder(ele) {
    ele.siblings(".hours-entry-dates-holder").toggle()
  }

  function toggleBackFromBottomSection(ele) {
    ele.parents(".role-description").siblings(".top-section").find(".edit-role-title-input-holder").toggle()
    ele.siblings(".role-description-input-holder").toggle()
  }

  function displayEditedDetails(ele, title, description) {
    if (title == "") {
      title = $(".edit-role-title-input-holder").attr("data-empty-text")
    }

    if (description == "") {
      description = $(".role-description-input-holder").attr("data-empty-text")
    }

    ele.parents(".role-description").siblings(".top-section").find(".edit-role-title").text(title)
    ele.siblings(".edit-role-description-text").find(".edit-role-description").text(description)
  }
}]);