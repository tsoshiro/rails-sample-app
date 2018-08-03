if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => 'AKIAJSMMBZ3KJCBFDXPA',
      :aws_secret_access_key => '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',
      :region                => 'us-east-1'
    }
    config.fog_directory     = 'jp.pixelbeat.rails-tutorial'
  end
end
    