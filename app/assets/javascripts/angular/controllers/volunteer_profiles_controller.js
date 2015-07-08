var app = angular.module('timeauction');

app.controller('VolunteerProfilesCtrl', ['$scope', 'Roles', 'Users', function($scope, Roles, Users) {
  $("body").on("click", ".hours-entry-date-toggle", function() {
    $(this).siblings(".hours-entry-details").toggle()
    $(this).find(".fa-plus-circle").toggle()
    $(this).find(".fa-minus-circle").toggle()
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

    ele.parents(".role-description").siblings(".top-section").find(".edit-role-title").html(title)
    ele.siblings(".edit-role-description-text").find(".edit-role-description").html(Users.makeIntoParagraphs(description))
  }

  $scope.showVolunteerDetails = function(event) {
    var ele = null
    if ($(event.target).hasClass("show-details-button")) {
      ele = $(event.target).siblings(".hours-entry-dates-holder")
      $(event.target).find(".show-details-text").toggle()
      $(event.target).find(".hide-details-text").toggle()
    } else {
      ele = $(event.target).parents(".show-details-button").siblings(".hours-entry-dates-holder")
      $(event.target).toggle()
      $(event.target).siblings(".other-detail-type").toggle()
    } 
    ele.toggle()
  }
}]);