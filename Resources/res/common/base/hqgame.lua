
local ccrypto = require "ccrypto"

---@classdef crypto
local crypto = {
    ENCRYPT_INV    = 0,
    ENCRYPT_NONE   = 1,
    ENCRYPT_XOR    = 2, 
    ENCRYPT_XXTEA  = 3,
    ENCRYPT_QTEA   = 4,
    ENCRYPT_MAX    = 5,
}

for k, v in pairs(ccrypto) do
    crypto[k] = v
end

function crypto.encodeBase64(plaintext)
    return CCEncode:encodeBase64(plaintext, string.len(plaintext))
end

function crypto.decodeBase64(ciphertext)
    return CCEncode:decodeBase64(ciphertext)
end

function crypto.md5(input, isRawOutput)
    if type(isRawOutput) ~= "boolean" then isRawOutput = false end
    return CCEncode:MD5(input, isRawOutput)
end

function crypto.md5str(input, inputLen, isRawOutput)
    if type(isRawOutput) ~= "boolean" then isRawOutput = false end
    return CCEncode:MD5Str(input, inputLen, isRawOutput)
end

function crypto.md5file(path)
    return CCEncode:MD5File(path)
end   

function crypto.encrypt(entype, dataInput, keys)
    log.debug("crypto.encrypt:entype=%s",entype)
    if entype == crypto.ENCRYPT_NONE then
        return dataInput
    elseif entype == crypto.ENCRYPT_XOR then
        return crypto.encXor(dataInput, keys)
    elseif entype == crypto.ENCRYPT_XXTEA then
        return crypto.encXxtea(dataInput, keys)
    elseif entype == crypto.ENCRYPT_QTEA then
        return crypto.encQtea(dataInput, keys)
    end
    
    return dataInput
end

function crypto.decrypt(entype, dataInput, keys)
    if entype == crypto.ENCRYPT_NONE then
        return dataInput
    elseif entype == crypto.ENCRYPT_XOR then
        return crypto.decXor(dataInput, keys)
    elseif entype == crypto.ENCRYPT_XXTEA then
        return crypto.decXxtea(dataInput, keys)
    elseif entype == crypto.ENCRYPT_QTEA then
        return crypto.decQtea(dataInput, keys)
    end
    
    return dataInput
end

function crypto.clef(idx)
    return ccrypto.clef(idx)
end

return crypto

