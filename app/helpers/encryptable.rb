require 'openssl'

module Encryptable

    def initialize
        generate_keys
        @status = :decrypted
        @content = nil
    end

    generate_keys

end
