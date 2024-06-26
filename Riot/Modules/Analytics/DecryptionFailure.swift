// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import AnalyticsEvents

@objc enum DecryptionFailureReason: Int {
    case unspecified
    case olmKeysNotSent
    case olmIndexError
    
    var errorName: AnalyticsEvent.Error.Name {
        switch self {
        case .unspecified:
            return .OlmUnspecifiedError
        case .olmKeysNotSent:
            return .OlmKeysNotSentError
        case .olmIndexError:
            return .OlmIndexError
        }
    }
}

/// `DecryptionFailure` represents a decryption failure.
@objcMembers class DecryptionFailure: NSObject {
    /// The id of the event that was unabled to decrypt.
    let failedEventId: String
    /// The time the failure has been reported.
    let ts: TimeInterval
    /// Decryption failure reason.
    let reason: DecryptionFailureReason
    /// Additional context of failure
    let context: String
    
    /// UTDs can be permanent or temporary. If temporary, this field will contain the time it took to decrypt the message in milliseconds. If permanent should be nil
    var timeToDecrypt: TimeInterval?
    
    /// Was the current cross-signing identity trusted at the time of decryption
    var trustOwnIdentityAtTimeOfFailure: Bool?
    
    var eventLocalAgeMillis: Int?
    
    /// Is the current user on matrix org
    var isMatrixOrg: Bool?
    /// Are the sender and recipient on the same homeserver
    var isFederated: Bool?
    
    /// As for now the ios App only reports UTDs visible to user (error are reported from EventFormatter
    var wasVisibleToUser: Bool = true
    
    init(failedEventId: String, reason: DecryptionFailureReason, context: String, ts: TimeInterval) {
        self.failedEventId = failedEventId
        self.reason = reason
        self.context = context
        self.ts = ts
    }
}
