require 'prime'

class Chat

    # Generate keys for current user if they don't exist
    # User should also be able to force an update
    # How should users generate a secure key on their machine?
    # Save public key to web DB
    # Load each user's info into a chat

end

class MessageSender

    def initialize(message_object, recipient)
        @message = message_object
        @recipient = recipient
    end

    def send
        puts "Finding user '#{@recipient}'"
        puts "Sending message: #{@message.message}"
    end

end

class SecureMessage
    attr_reader :product, :public_key, :message

    def initialize(message)
        generate_keys
        @message = message.chars
        @status = :decrypted
    end

    def encrypt
        if @status == :decrypted
            @message.map! {|c| c.ord}
            @message.map! {|a| a**@public_key % @product}
            @status = :encrypted
            @message
        else
            raise(AlreadyEncryptedError, "The message is already encrypted.")
        end
    end

    def decrypt
        if @status == :encrypted
            @message.map! {|a| a**@private_key % @product}
            @message.map! {|c| c.chr}
            @status = :decrypted
            @message.to_s
        else
            raise(AlreadyDecryptedError, "The message is already decrypted.")
        end
    end

    private

    def generate_keys
        @key1 = generate_prime
        @key2 = generate_prime
        puts "generating complex keys..."
        @product = @key1 * @key2
        @totient = (@key1 - 1) * (@key2 - 1)
        puts "done"
        @public_key = generate_public
        puts "finished generating keys:"
        puts "key1 = #{@key1}"
        puts "key2 = #{@key2}"
        puts "product = #{@product}"
        puts "totient = #{@totient}"
        puts "public_key = #{@public_key}"
        puts "private_key = #{@private_key}"
    end

    def generate_prime
        puts "generating prime..."
        new_key = nil
        while new_key == nil do
            attempt = Random.new.rand(10000)
            new_key = Prime.prime?(attempt) ? attempt : nil
        end
        attempt = nil
        puts "done"
        new_key
    end

    def generate_public
        puts "generating public key..."
        primes = []
        Prime.each(@totient) do |prime| # Replaced @totient with 1000000
            primes << prime
        end
        primes.sort!.slice!(0, 10000)
        n = 0
        chosen_prime = nil
        while chosen_prime == nil do
            this_prime = primes[n]
            chosen_prime = (@totient % this_prime != 0) ? this_prime : nil
            n += 1
        end
        puts "done"
        chosen_prime
    end
end

class SecureKeys

end

class User

    def initialize

    end

end

class AlreadyEncryptedError < StandardError
end

class AlreadyDecryptedError < StandardError
end

EncryptedMessage = Struct.new(:output) do
    def encrypt
        puts "this is encrypted"
    end
end

def send(text, recipient)
    @message = SecureMessage.new text
    @message.encrypt
    @sender = MessageSender.new @message, recipient
    @sender.send
end
