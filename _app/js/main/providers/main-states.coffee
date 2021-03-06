'use strict'
app = angular.module("MainApp")

app.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
    view_url = "/partials/main"
    # redirects
    $urlRouterProvider.when('', '/')
    $urlRouterProvider.when('/u/:username', '/u/:username/overview')
    # $urlRouterProvider.otherwise('/all')
    # application states
    home =
      name: "home"
      abstract: true
      templateUrl: "#{view_url}/layout.html"
      controller: "navCtrl"
      resolve:
        NetworkSubscriptions: ["NetworkSubscriptionResource", "$stateParams", "$state", "$rootScope", "$auth", (NetworkSubscriptionResource, $stateParams, $state, $rootScope, $auth) ->
          NetworkSubscriptionResource.query()
        ]

    all =
      name: "home.all"
      url: "/"
      templateUrl: "#{view_url}/posts.html"
      controller: ["$scope", "Page", ($scope, Page) ->
        $scope.page = Page
      ]
      resolve:
        Posts: ["PostResource", "$stateParams", "$state", "$rootScope", "$auth", (PostResource, $stateParams, $state, $rootScope, $auth) ->
          PostResource.query({scope: "all"})
        ]
      onEnter: ["Page", (Page) ->
        Page.scope = "all"
      ]

    
    network =
      name: "home.network"
      url: "/n/:network"
      templateUrl: "#{view_url}/posts.html"
      onEnter: ["Page", (Page) ->
        Page.scope = "network"
        
      ]
      controller: "networkCtrl"
      resolve:
        Network: ["NetworkResource", "$stateParams", "$state", "$rootScope", "$auth", (NetworkResource, $stateParams, $state, $rootScope, $auth) ->
          NetworkResource.show({id: $stateParams.network})

        ]
        Posts: ["NetworkResource", "$stateParams", "$state", "$rootScope", "$auth", (NetworkResource, $stateParams, $state, $rootScope, $auth) ->
          NetworkResource.posts({id: $stateParams.network})
        ]


    community =
      name: "home.community"
      url: "/c/:community"
      onEnter: ["Page", (Page) ->
        Page.scope = "community"
      ]
      resolve:
        Community: ["CommunityResource", "$stateParams", (CommunityResource, $stateParams) ->
          CommunityResource.show({id: $stateParams.community})
        ]
        Posts: ["CommunityResource", "$stateParams", (CommunityResource, $stateParams) ->
          CommunityResource.posts({id: $stateParams.community})
        ]
      templateUrl: "#{view_url}/posts.html"
      controller: "communityCtrl"

    submit =
      name: "home.community.submit"
      url: "/submit"
      onEnter: ["Page", (Page) ->
        Page.scope = "submit"
      ]
      views:
        "@home": 
          templateUrl: "#{view_url}/submit.html"
          controller: "submitCtrl"
          Community: ["CommunityResource", "$stateParams", (CommunityResource, $stateParams) ->
            CommunityResource.show({id: $stateParams.community})
          ]
    create = 
      name: "create"
      url: "/create"
      templateUrl: "#{view_url}/create/layout.html"
      controller: "createCtrl"
      resolve:
        NetworkSubscriptions: ["NetworkSubscriptionResource", "$stateParams", "$state", "$rootScope", "$auth", (NetworkSubscriptionResource, $stateParams, $state, $rootScope, $auth) ->
          NetworkSubscriptionResource.query()
        ]
    comments = 
      name: "home.community.comments"
      url: "/:id"
      onEnter: ["Page", (Page) ->
        Page.scope = "comments"
      ]
      resolve: 
        Post: ["PostResource", "$stateParams", (PostResource, $stateParams) ->
          PostResource.get({id: $stateParams.id})
        ]
        Comments: ["PostResource", "$stateParams", (PostResource, $stateParams) ->
          PostResource.comments({id: $stateParams.id})
        ]
      views:
        "@home": 
          templateUrl: "#{view_url}/comments.html"
          controller: "commentsCtrl"
    
    # user = 
    #   name: "user"
    #   url: "/u/"
    #   abstract: true
    #   templateUrl: "#{view_url}/user/layout.html"
    #   controller: "userCtrl"
    
    # user_overview = 
    #   name: "user.overview"
    #   url: "/:username"
    #   templateUrl: "#{view_url}/user/overview.html"
    #   controller: ["$scope", ($scope) ->
    #   ]

    # user_voted = 
    #   name: "user.voted"
    #   url: "/:voted"      
    #   templateUrl: "#{view_url}/user/voted.html"
    #   controller: ["$scope", ($scope) ->
    #   ] 

    $stateProvider.state(home)
    $stateProvider.state(all)
    $stateProvider.state(network)
    $stateProvider.state(community)
    $stateProvider.state(submit)
    $stateProvider.state(create)
    $stateProvider.state(comments)
    # $stateProvider.state(user)
    # $stateProvider.state(user_overview)
    # $stateProvider.state(user_voted)


])
