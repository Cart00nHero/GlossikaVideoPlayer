// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: VideoPlayerPB.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Video {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var description_p: String = String()

  var sources: [String] = []

  var subtitle: String = String()

  var thumb: String = String()

  var title: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct VideoCategory {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var name: String = String()

  var videos: [Video] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct MediaData {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var categories: [VideoCategory] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Video: @unchecked Sendable {}
extension VideoCategory: @unchecked Sendable {}
extension MediaData: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Video: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Video"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "description"),
    2: .same(proto: "sources"),
    3: .same(proto: "subtitle"),
    4: .same(proto: "thumb"),
    5: .same(proto: "title"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 2: try { try decoder.decodeRepeatedStringField(value: &self.sources) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.thumb) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.title) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 1)
    }
    if !self.sources.isEmpty {
      try visitor.visitRepeatedStringField(value: self.sources, fieldNumber: 2)
    }
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 3)
    }
    if !self.thumb.isEmpty {
      try visitor.visitSingularStringField(value: self.thumb, fieldNumber: 4)
    }
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Video, rhs: Video) -> Bool {
    if lhs.description_p != rhs.description_p {return false}
    if lhs.sources != rhs.sources {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.thumb != rhs.thumb {return false}
    if lhs.title != rhs.title {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCategory: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "VideoCategory"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "videos"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.videos) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    if !self.videos.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.videos, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCategory, rhs: VideoCategory) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.videos != rhs.videos {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension MediaData: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "MediaData"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "categories"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.categories) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.categories.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.categories, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: MediaData, rhs: MediaData) -> Bool {
    if lhs.categories != rhs.categories {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
