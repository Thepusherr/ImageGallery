// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Manually import controllers
import HelloController from "controllers/hello_controller"
import CommentsController from "controllers/comments_controller"
import CommentsToggleController from "controllers/comments_toggle_controller"
import ImagePreviewController from "controllers/image_preview_controller"
import LikesController from "controllers/likes_controller"
import ModalController from "controllers/modal_controller"
import TubesCursorController from "controllers/tubes_cursor_controller"

// Register controllers
application.register("hello", HelloController)
application.register("comments", CommentsController)
application.register("comments-toggle", CommentsToggleController)
application.register("image-preview", ImagePreviewController)
application.register("likes", LikesController)
application.register("modal", ModalController)
application.register("tubes-cursor", TubesCursorController)
